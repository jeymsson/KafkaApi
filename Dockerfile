# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the official ASP.NET Core SDK as a build image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["App/KafkaApi.csproj", "App/"]
RUN dotnet restore "App/KafkaApi.csproj"
COPY . .
WORKDIR "/src/App"
RUN dotnet build "KafkaApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KafkaApi.csproj" -c Release -o /app/publish

# Use the base image to run the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KafkaApi.dll"]