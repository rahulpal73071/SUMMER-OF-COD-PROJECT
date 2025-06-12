// controllers/orderController.js
const Order = require('../models/Order');

exports.placeOrder = async (req, res) => {
  const { products, shippingAddress, totalAmount } = req.body;
  try {
    const order = await Order.create({
      userId: req.user.id,
      products,
      shippingAddress,
      totalAmount
    });
    res.status(201).json(order);
  } catch (err) {
    res.status(500).json({ message: 'Order failed', error: err.message });
  }
};

exports.getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user.id });
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ message: 'Fetch failed', error: err.message });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find({}).populate('userId', 'name email');
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ message: 'Admin fetch failed', error: err.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  const { status } = req.body;
  try {
    const order = await Order.findByIdAndUpdate(req.params.id, { status }, { new: true });
    res.status(200).json(order);
  } catch (err) {
    res.status(500).json({ message: 'Status update failed', error: err.message });
  }
};
