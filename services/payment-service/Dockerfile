# Stage 1: Compile application
FROM ://microsoft.com AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o out

# Stage 2: .NET Runtime environment
FROM ://microsoft.com
WORKDIR /app
COPY --from=builder /app/out .
EXPOSE 8085
ENTRYPOINT ["dotnet", "payment-service.dll"]
