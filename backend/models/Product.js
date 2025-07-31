const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  title: String,
  description: String,
  price: Number,
  quantity: Number,
  images: [String],
  category: String,
  rating: {
    rate: { type: Number, default: 0 },
    count: { type: Number, default: 0 }
  }
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
