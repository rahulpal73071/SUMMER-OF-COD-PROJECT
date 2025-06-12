// controllers/userController.js
const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ message: 'Cannot fetch profile', error: err.message });
  }
};

exports.updateAddress = async (req, res) => {
  const { address } = req.body;
  try {
    const user = await User.findByIdAndUpdate(req.user.id, { address }, { new: true });
    res.status(200).json({ message: 'Address updated', address: user.address });
  } catch (err) {
    res.status(500).json({ message: 'Update failed', error: err.message });
  }
};
