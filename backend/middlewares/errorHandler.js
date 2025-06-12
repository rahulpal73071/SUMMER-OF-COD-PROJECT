// middlewares/errorHandler.js

const errorHandler = (err, req, res, next) => {
  console.error('❌ Error:', err.stack || err.message);

  const status = res.statusCode !== 200 ? res.statusCode : 500;

  res.status(status).json({
    success: false,
    message: err.message || 'Internal Server Error',
    stack: process.env.NODE_ENV === 'production' ? null : err.stack
  });
};

module.exports = errorHandler;
