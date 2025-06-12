// routes/productRoutes.js
const express = require('express');
const upload = require('../utils/multer');
const {
  createProduct,
  getAllProducts,
  getProductById,
  updateProduct,
  deleteProduct
} = require('../controllers/productController');

const { authenticate, adminOnly } = require('../middlewares/auth');

const router = express.Router();

router.post('/', authenticate, adminOnly, upload.array('images', 5), createProduct);
router.get('/', getAllProducts);
router.get('/:id', getProductById);
router.put('/:id', authenticate, adminOnly, updateProduct);
router.delete('/:id', authenticate, adminOnly, deleteProduct);

module.exports = router;
