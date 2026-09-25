# MenuGoBE

## Deploy on Railway

Railway can deploy this project directly from the repository. The included
`Dockerfile` uses .NET 9 and the application listens on Railway's `PORT`
environment variable. The `/health` endpoint is configured as the Railway
health check.

Set these variables in the Railway service before deploying:

```text
ConnectionStrings__DefaultConnection
Jwt__Key
Jwt__Issuer
Jwt__Audience
PayOS__ClientId
PayOS__ApiKey
PayOS__ChecksumKey
CloudinarySettings__CloudName
CloudinarySettings__ApiKey
CloudinarySettings__ApiSecret
MailSettings__Mail
MailSettings__Password
MailSettings__Host
MailSettings__Port
```

Use the PostgreSQL connection string supplied by the database provider for
`ConnectionStrings__DefaultConnection`. Do not commit credentials to
`appsettings.json`; ASP.NET Core environment variables override the empty
local defaults.

For Cloudinary uploads, the three Cloudinary variables must belong to the same
Cloudinary product environment:

```text
CloudinarySettings__CloudName=<cloudinary cloud name>
CloudinarySettings__ApiKey=<cloudinary API key>
CloudinarySettings__ApiSecret=<current cloudinary API secret>
```

Do not include surrounding quotes or whitespace in these Railway variable
values. If Cloudinary reports `Invalid Signature`, open the Cloudinary
Dashboard, copy the current API secret again, update
`CloudinarySettings__ApiSecret` in Railway, and redeploy the service. A
signature generated with an old or different account secret cannot be repaired
by changing the upload request.

For local development, configure the same values with .NET user secrets or
environment variables, then run:

```powershell
dotnet restore
dotnet run --project .\MenuGoBE.csproj
```
