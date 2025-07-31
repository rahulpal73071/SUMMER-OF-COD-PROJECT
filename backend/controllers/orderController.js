// controllers/orderController.js
const Order = require('../models/Order');

exports.placeOrder = async (req, res) => {
  const {
    products,
    shippingAddress,
    totalAmount,
    userEmail,
    paymentStatus
  } = req.body;

  try {
    const order = await Order.create({
      userEmail,
      products,
      shippingAddress,
      totalAmount,
      
      paymentStatus: paymentStatus || 'Completed'  // fallback if not sent
    });

    res.status(201).json(order);
  } catch (err) {
    res.status(500).json({ message: 'Order failed', error: err.message });
  }
};

exports.getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ userName: req.user.email }); // use `userName` instead of userId
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ message: 'Fetch failed', error: err.message });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find({});
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ message: 'Admin fetch failed', error: err.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  const { status } = req.body;
  try {
    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );
    res.status(200).json(order);
  } catch (err) {
    res.status(500).json({ message: 'Status update failed', error: err.message });
  }
};
