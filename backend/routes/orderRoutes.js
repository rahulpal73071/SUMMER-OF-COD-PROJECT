// routes/orderRoutes.js
const express = require('express');
const {
  placeOrder,
  getUserOrders,
  getAllOrders,
  updateOrderStatus
} = require('../controllers/orderController');

const { authenticate, adminOnly } = require('../middlewares/auth');

const router = express.Router();

// Place order
router.post('/',  placeOrder);

// Get user's own orders
router.get('/my',  getUserOrders);

// Admin: get all orders
router.get('/admin',  getAllOrders);

// Admin: update order status
router.put('/:id/status',  updateOrderStatus);

module.exports = router;
