// routes/paymentRoutes.js
const express = require('express');
const { createPaymentIntent } = require('../controllers/paymentController');
const { authenticate } = require('../middlewares/auth');

const router = express.Router();

router.post('/create', authenticate, createPaymentIntent);

module.exports = router;
