FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

# Npgsql can load GSSAPI/Kerberos support when opening PostgreSQL connections.
# Keep the runtime image self-contained so a database connection cannot crash
# the app after startup.
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*
USER $APP_UID


FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["MenuGoBE.csproj", "./"]
RUN dotnet restore "./MenuGoBE.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./MenuGoBE.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore


FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./MenuGoBE.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "dotnet MenuGoBE.dll --urls http://+:${PORT:-8080}"]
