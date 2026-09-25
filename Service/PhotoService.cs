using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using MenuGoBE.Helpers;
using MenuGoBE.Interface.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using System;
using System.IO;
using System.Threading.Tasks;

namespace MenuGoBE.Service
{
    public class PhotoService : IPhotoService
    {
        private readonly Cloudinary _cloudinary;

        public PhotoService(IOptions<CloudinarySettings> config)
        {
            var settings = config.Value;
            var cloudName = settings.CloudName.Trim().Trim('"');
            var apiKey = settings.ApiKey.Trim().Trim('"');
            var apiSecret = settings.ApiSecret.Trim().Trim('"');

            if (string.IsNullOrWhiteSpace(cloudName) ||
                string.IsNullOrWhiteSpace(apiKey) ||
                string.IsNullOrWhiteSpace(apiSecret))
            {
                throw new InvalidOperationException(
                    "CloudinarySettings must contain CloudName, ApiKey, and ApiSecret.");
            }

            var acc = new Account(
                cloudName,
                apiKey,
                apiSecret
            );

            _cloudinary = new Cloudinary(acc);
        }

        public async Task<ImageUploadResult> AddPhotoAsync(IFormFile file)
        {
            var uploadResult = new ImageUploadResult();

            if (file.Length > 0)
            {
                using var stream = file.OpenReadStream();
                var uploadParams = new ImageUploadParams
                {
                    File = new FileDescription(file.FileName, stream),
                    Folder = "menugo_uploads",
                    Transformation = new Transformation().Height(800).Width(800).Crop("limit")
                };
                uploadResult = await _cloudinary.UploadAsync(uploadParams);
            }

            return uploadResult;
        }

        public async Task<DeletionResult> DeletePhotoAsync(string publicId)
        {
            var deleteParams = new DeletionParams(publicId);
            return await _cloudinary.DestroyAsync(deleteParams);
        }
    }
}
