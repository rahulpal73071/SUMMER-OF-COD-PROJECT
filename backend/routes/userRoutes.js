// routes/userRoutes.js
const express = require('express');
const { getProfile, updateAddress } = require('../controllers/userController');
const { authenticate } = require('../middlewares/auth');

const router = express.Router();

router.get('/profile', authenticate, getProfile);
router.put('/address', authenticate, updateAddress);

module.exports = router;
