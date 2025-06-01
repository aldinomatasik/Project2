const net = require('net');

const host = process.env.DB_HOST || 'localhost';
const port = parseInt(process.env.DB_PORT) || 3306;
const retryInterval = 1000;

function checkMySQL() {
  const socket = net.createConnection(port, host);
  socket.on('connect', () => {
    console.log('✅ MySQL is ready. Starting server...');
    socket.end();
    require('./server');
  });
  socket.on('error', () => {
    console.log('⏳ Waiting for MySQL...');
    setTimeout(checkMySQL, retryInterval);
  });
}

checkMySQL();
