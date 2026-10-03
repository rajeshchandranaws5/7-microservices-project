# Stage 1: Build the binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
# Download dependencies
RUN go mod download
COPY . .
# Compile a static binary without external C dependencies
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Ultra-lightweight runner
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8082
CMD ["./main"]
