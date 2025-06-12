// controllers/paymentController.js
const Stripe = require('stripe');
require('dotenv').config();
const stripe = new Stripe(process.env.PAYMENT_SECRET);

exports.createPaymentIntent = async (req, res) => {
  try {
    const { amount } = req.body;
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount * 100, // in paise or cents
      currency: 'inr',
      payment_method_types: ['card']
    });
    res.status(200).json({ clientSecret: paymentIntent.client_secret });
  } catch (err) {
    res.status(500).json({ message: 'Payment failed', error: err.message });
  }
};
