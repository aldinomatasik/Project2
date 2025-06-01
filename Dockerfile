# Gunakan image Node.js
FROM node:18

# Buat direktori kerja
WORKDIR /app

# Salin file konfigurasi dan install dependencies
COPY package*.json ./
RUN npm install

# Salin semua file
COPY . .

# Jalankan aplikasi
CMD ["node", "server.js"]
