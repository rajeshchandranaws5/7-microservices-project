FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
# Install only production dependencies for safety and speed
RUN npm ci --only=production
COPY . .
EXPOSE 8083
CMD ["npm", "start"]
