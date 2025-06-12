const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  title: String,
  description: String,
  price: Number,
  quantity: Number,
  images: [String],
  category: String,
  rating: {
    rate: Number,
    count: Number
  }
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
