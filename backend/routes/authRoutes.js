// routes/authRoutes.js
const express = require('express');
const { register, login } = require('../controllers/authController');
const { check } = require('express-validator');
const { runValidation } = require('../middlewares/validate');

const router = express.Router();

router.post(
  '/register',
  [
    check('name', 'Name is required').notEmpty(),
    check('email', 'Valid email required').isEmail(),
    check('password', 'Min 6 chars').isLength({ min: 6 })
  ],
  runValidation,
  register
);

router.post(
  '/login',
  [
    check('email', 'Valid email required').isEmail(),
    check('password', 'Password required').notEmpty()
  ],
  runValidation,
  login
);

module.exports = router;
