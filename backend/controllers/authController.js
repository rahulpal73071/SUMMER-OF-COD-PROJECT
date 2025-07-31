// controllers/authController.js
const bcrypt = require('bcryptjs');
const User = require('../models/User');
const { generateToken } = require('../config/jwt');

exports.register = async (req, res) => {
  const { name, email, password, phone, role , address } = req.body;  // Include role

  try {
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: 'Email already exists' });

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      phone,
      address,
      role: role || 'user'  // default to 'user' if not provided
    });

    const token = generateToken(user);

    res.status(201).json({ user, token });
  } catch (err) {
    res.status(500).json({ message: 'Registration failed', error: err.message });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ message: 'Invalid credentials' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Invalid credentials' });

    const token = generateToken(user);
    res.status(200).json({ user, token });
  } catch (err) {
    res.status(500).json({ message: 'Login failed', error: err.message });
  }
};


exports.updateUser = async (req, res) => {
  try {
    const updates = req.body;
    const userId = req.user._id;

    // Prevent role change via update
    if (updates.role) {
      return res.status(403).json({ message: 'Role update is not allowed' });
    }

    // If password is being updated, hash it
    if (updates.password) {
      updates.password = await bcrypt.hash(updates.password, 10);
    }

    const updatedUser = await User.findByIdAndUpdate(userId, updates, {
      new: true,
      runValidators: true,
      context: 'query',
    }).select('-password');

    res.status(200).json({ message: 'User updated successfully', user: updatedUser });
  } catch (err) {
    res.status(500).json({ message: 'Update failed', error: err.message });
  }
};
