const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async ()=>{
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("connected to Database");
        
    } catch (error) {
        console.log(error.message);
        process.exit(1);
    }
};

module.exports = connectDB;