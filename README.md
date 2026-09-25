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

For local development, configure the same values with .NET user secrets or
environment variables, then run:

```powershell
dotnet restore
dotnet run --project .\MenuGoBE.csproj
```
