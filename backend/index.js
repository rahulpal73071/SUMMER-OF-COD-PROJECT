// index.js

require('dotenv').config(); // Load .env variables
const express = require('express');
const morgan = require('morgan');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const errorHandler = require('./middlewares/errorHandler');
const { logger } = require('./utils/logger');

// Patch to make req.query writable for express-mongo-sanitize fix
Object.defineProperty(require('http').IncomingMessage.prototype, 'query', {
  writable: true,
});

// Import Routes
const authRoutes = require('./routes/authRoutes');
// const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');
const paymentRoutes = require('./routes/paymentRoutes');

// App init
const app = express();

// Connect to DB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('🟢 MongoDB connected successfully')
  )
  .catch((err) => {
    logger(`🔴 MongoDB connection error: ${err}`, 'ERROR');
    process.exit(1);
  });

// Global Middlewares
app.use(helmet());
app.use(cors({ origin: process.env.CLIENT_URL, credentials: true }));
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(mongoSanitize({ replaceWith: '_' })); // Now safely works with patched req.query
app.use(xss());
app.use('/uploads', express.static('uploads'));

if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
}

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  message: 'Too many requests, try again later.'
});
app.use('/api', limiter);

// Routes
app.use('/api/auth', authRoutes);
// app.use('/api/user', userRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);

// Health Check
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Error handler (must be last)
app.use(errorHandler);

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT,'0.0.0.0', () => {
  console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
  
});
