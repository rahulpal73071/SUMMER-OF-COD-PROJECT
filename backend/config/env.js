// config/env.js
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const requiredEnvs = ['PORT', 'MONGO_URI', 'JWT_SECRET', 'PAYMENT_SECRET'];

requiredEnvs.forEach((envVar) => {
  if (!process.env[envVar]) {
    console.error(`❌ Missing required environment variable: ${envVar}`);
    process.exit(1);
  }
});

module.exports = {
  PORT: process.env.PORT || 5000,
  MONGO_URI: process.env.MONGO_URI,
  JWT_SECRET: process.env.JWT_SECRET,
  PAYMENT_SECRET: process.env.PAYMENT_SECRET
};
