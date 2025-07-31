// routes/authRoutes.js
const express = require('express');
const { register, login, updateUser } = require('../controllers/authController');
const { verifyToken } = require('../middlewares/auth');
const { check } = require('express-validator');
const { runValidation } = require('../middlewares/validate');
const router = express.Router();

router.post(
  '/register',
  [
    check('name', 'Name is required').notEmpty(),
    check('address' , 'Address is requied').notEmpty(),
    check('email', 'Valid email required').isEmail(),
    check('password', 'Min 6 chars').isLength({ min: 6 }),
    check('role').optional().isIn(['user', 'admin']).withMessage('Role must be user or admin')
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

// 👇 NEW update route
router.put(
  '/update',
  
  [
    check('email').optional().isEmail().withMessage('Must be a valid email'),
    check('name').optional().notEmpty().withMessage('Name cannot be empty'),
    check('phone').optional(),
    check('address').optional().isString(),
    check('role').not().exists().withMessage('Role update is not allowed')
  ],
  runValidation,
  updateUser
);
module.exports = router;
