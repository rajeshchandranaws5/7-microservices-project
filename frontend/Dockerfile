# Stage 1: Compile production static assets
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve using an efficient Nginx web server
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
# If using React router, you might need custom nginx configs later
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
