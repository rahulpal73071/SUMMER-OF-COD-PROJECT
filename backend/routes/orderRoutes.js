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

router.post('/', authenticate, placeOrder);
router.get('/my', authenticate, getUserOrders);
router.get('/admin', authenticate, adminOnly, getAllOrders);
router.put('/:id/status', authenticate, adminOnly, updateOrderStatus);

module.exports = router;
