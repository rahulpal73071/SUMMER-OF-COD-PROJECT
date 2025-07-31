const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, trim: true },
  email: { type: String, unique: true, trim: true },
  password: String,
  role: { type: String, enum: ['user', 'admin'], default: 'user' },
  address: String,
  phone: String
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
