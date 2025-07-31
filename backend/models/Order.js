const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  userEmail: String,
  products: [{
    productName: String,
    quantity: Number,
    Image:String,

  }],
  totalAmount: Number,
  shippingAddress: String,
  status: { type: String, enum: ['Pending', 'Processing', 'Shipped', 'Delivered'], default: 'Pending' },
  paymentStatus: { type: String, enum: ['Pending', 'Completed'], default: 'Pending' }
}, { timestamps: true });

module.exports = mongoose.model('Order', orderSchema);
