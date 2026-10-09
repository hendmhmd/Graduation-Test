
# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy the repository files into the build stage
COPY . .

# Restore dependencies for the API project
RUN dotnet restore "src/KidsCompanion.Api/KidsCompanion.Api.csproj"

# Publish the API
RUN dotnet publish "src/KidsCompanion.Api/KidsCompanion.Api.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final

WORKDIR /app

# Copy only published application files
COPY --from=build /app/publish .

# Configure ASP.NET Core to listen on port 8080
ENV ASPNETCORE_HTTP_PORTS=8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "KidsCompanion.Api.dll"]