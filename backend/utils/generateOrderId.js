// utils/generateOrderId.js
const crypto = require('crypto');

exports.generateOrderId = () => {
  const timestamp = Date.now().toString();
  const randomStr = crypto.randomBytes(4).toString('hex');
  return `ORD-${timestamp}-${randomStr}`.toUpperCase();
};
