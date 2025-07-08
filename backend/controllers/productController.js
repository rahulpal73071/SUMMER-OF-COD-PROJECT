// controllers/productController.js
const Product = require('../models/Product');

exports.createProduct = async (req, res) => {
  try {
    const { title, description, price, quantity, category } = req.body;

    // Get image paths
    const imagePaths = req.files.map(file => `${req.protocol}://${req.get('host')}/uploads/${file.filename}`);

    const product = new Product({
      title,
      description,
      price,
      quantity,
      images: imagePaths,
      category,
      rating: { rate: 0, count: 0 }
    });

    const savedProduct = await product.save();
    res.status(201).json({ message: 'Product created', product: savedProduct });
  } catch (err) {
    console.error('Error creating product:', err);
    res.status(500).json({ error: 'Failed to create product', message: err.message });

  }
};

exports.getAllProducts = async (req, res) => {
  try {
    const { category, minRating, sort } = req.query;

    let query = {};

    // ✅ Filter by category
    if (category) {
      query.category = category;
    }

    // ✅ Filter by rating
    if (minRating) {
      query['rating.rate'] = { $gte: parseFloat(minRating) };
    }

    let sortOption = {};

    // ✅ Sorting
    if (sort === 'price_asc') {
      sortOption.price = 1;
    } else if (sort === 'price_desc') {
      sortOption.price = -1;
    }

    const products = await Product.find(query).sort(sortOption);

    res.status(200).json(products);
  } catch (err) {
    console.error('Fetch products error:', err);
    res.status(500).json({ message: 'Fetch failed', error: err.message });
  }
};


exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.status(200).json(product);
  } catch (err) {
    res.status(500).json({ message: 'Fetch failed', error: err.message });
  }
};

exports.updateProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.status(200).json(product);
  } catch (err) {
    res.status(500).json({ message: 'Update failed', error: err.message });
  }
};

exports.deleteProduct = async (req, res) => {
  try {
    await Product.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Delete failed', error: err.message });
  }
};
