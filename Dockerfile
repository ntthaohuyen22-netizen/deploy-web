FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080


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
