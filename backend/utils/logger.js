// utils/logger.js
const fs = require('fs');
const path = require('path');

const logPath = path.join(__dirname, '../logs');
if (!fs.existsSync(logPath)) fs.mkdirSync(logPath);

const logFile = path.join(logPath, `server.log`);

exports.logger = (message, type = 'INFO') => {
  const log = `[${new Date().toISOString()}] [${type}] ${message}\n`;
  fs.appendFileSync(logFile, log);
  if (process.env.NODE_ENV !== 'production') console.log(log.trim());
};
