# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
# For more information, please see https://aka.ms/containercompat

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["DA.WebAPI/DA.WebAPI.csproj", "DA.WebAPI/"]
COPY ["Services/Auth/DA.Auth.ApplicationService/DA.Auth.ApplicationService.csproj", "Services/Auth/DA.Auth.ApplicationService/"]
COPY ["Services/Shared/DA.Shared.ApplicationService/DA.Shared.ApplicationService.csproj", "Services/Shared/DA.Shared.ApplicationService/"]
COPY ["Services/Auth/DA.Auth.Dtos/DA.Auth.Dtos.csproj", "Services/Auth/DA.Auth.Dtos/"]
COPY ["Services/Vehicle/DA.Vehicle.Dtos/DA.Vehicle.Dtos.csproj", "Services/Vehicle/DA.Vehicle.Dtos/"]
COPY ["Services/Shared/DA.Shared.Constant/DA.Shared.Constant.csproj", "Services/Shared/DA.Shared.Constant/"]
COPY ["Services/Shared/DA.Shared.Dtos/DA.Shared.Dtos.csproj", "Services/Shared/DA.Shared.Dtos/"]
COPY ["Services/Shared/DA.Shared.Untils/DA.Shared.Untils.csproj", "Services/Shared/DA.Shared.Untils/"]
COPY ["Services/Shared/DA.Shared.Exceptions/DA.Shared.Exceptions.csproj", "Services/Shared/DA.Shared.Exceptions/"]
COPY ["Services/Auth/DA.Auth.Infrastructure/DA.Auth.Infrastructure.csproj", "Services/Auth/DA.Auth.Infrastructure/"]
COPY ["Services/Auth/DA.Auth.Domain/DA.Auth.Domain.csproj", "Services/Auth/DA.Auth.Domain/"]
COPY ["Services/Booking/DA.Booking.ApplicationService/DA.Booking.ApplicationService.csproj", "Services/Booking/DA.Booking.ApplicationService/"]
COPY ["Services/Booking/DA.Booking.Dtos/DA.Booking.Dtos.csproj", "Services/Booking/DA.Booking.Dtos/"]
COPY ["Services/Booking/DA.Booking.Infrastucture/DA.Booking.Infrastucture.csproj", "Services/Booking/DA.Booking.Infrastucture/"]
COPY ["Services/Booking/DA.Booking.Domain/DA.Booking.Domain.csproj", "Services/Booking/DA.Booking.Domain/"]
COPY ["Services/Vehicle/DA.Vehicle.ApplicationService/DA.Vehicle.ApplicationService.csproj", "Services/Vehicle/DA.Vehicle.ApplicationService/"]
COPY ["Services/Vehicle/DA.Vehicle.Infrastructure/DA.Vehicle.Infrastructure.csproj", "Services/Vehicle/DA.Vehicle.Infrastructure/"]
COPY ["Services/Vehicle/DA.Vehicle.Domain/DA.Vehicle.Domain.csproj", "Services/Vehicle/DA.Vehicle.Domain/"]
RUN dotnet restore "./DA.WebAPI/DA.WebAPI.csproj"
COPY . .
WORKDIR "/src/DA.WebAPI"

RUN dotnet build "./DA.WebAPI.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DA.WebAPI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DA.WebAPI.dll"]