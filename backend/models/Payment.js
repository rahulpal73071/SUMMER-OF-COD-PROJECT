const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  paymentId: String,
  status: String,
  amount: Number,
  method: String
}, { timestamps: true });

module.exports = mongoose.model('Payment', paymentSchema);
