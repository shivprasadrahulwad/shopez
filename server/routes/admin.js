const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const { RentProduct } = require("../models/rentProduct");
const User=require("../models/user");
const Order = require("../models/order");
// const fs = require("fs").promises;
// const path = require("path");
// const util = require('util');
// const { ObjectId } = require('mongoose').Types; // Importing ObjectId for validation





//copy to cart
// adminRouter.post("/admin/copy-product", async (req, res) => {
//   try {
//     console.log("Request body:", req.body); // Print the entire request body for debugging

//     const { id, userId } = req.body; // Ensure userId and id are extracted from req.body

//     if (!userId || typeof userId !== 'string') {
//       return res.status(400).json({ error: "Valid User ID is required" });
//     }

//     console.log("User ID to check:", userId); // Log the userId

//     // Find the user by userId
//     const user = await User.findById(userId);

//     if (!user) {
//       return res.status(404).json({ error: "User not found" });
//     }

//     // Find the product by id
//     const product = await Product.findById(id);

//     if (!product) {
//       return res.status(404).json({ error: "Product not found" });
//     }

//     // Add the product to the user's cart
//     user.cart.push({
//       product: {
//         name: product.name,
//         description: product.description,
//         price: product.price,
//         discountPrice: product.discountPrice,
//         category: product.category,
//         subCategory: product.subCategory,
//         quantity: product.quantity,
//         images: product.images,
//         // Add other necessary fields from the product
//       }
//     });

//     // Save the user document with the updated cart
//     await user.save();

//     res.json({ message: "Product added to cart successfully" });
//   } catch (e) {
//     console.error("Error:", e.message); // Log the error for debugging
//     res.status(500).json({ error: e.message });
//   }
// });



//copy to cart
adminRouter.post("/admin/copy-product", async (req, res) => {
  try {
    console.log("Request body:", req.body); // Print the entire request body for debugging

    const { id, userId } = req.body; // Ensure userId and id are extracted from req.body

    if (!userId || typeof userId !== 'string') {
      return res.status(400).json({ error: "Valid User ID is required" });
    }

    console.log("User ID to check:", userId); // Log the userId

    // Find the user by userId
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Find the product by id
    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Check if the product already exists in the user's cart
    const productExistsInCart = user.cart.some(cartItem => cartItem.product._id.toString() === product._id.toString());

    if (productExistsInCart) {
      return res.status(400).json({ error: "Product already in cart" });
    }

    // Add the product to the user's cart
    user.cart.push({
      product: {
        _id: product._id,
        name: product.name,
        description: product.description,
        price: product.price,
        discountPrice: product.discountPrice,
        category: product.category,
        subCategory: product.subCategory,
        quantity: product.quantity,
        images: product.images,
        scheduleIndex : product.scheduleIndex,
        offer : product.offer
        // Add other necessary fields from the product
      },
      quantity: 1 // Assuming you want to add a quantity field, starting with 1
    });

    // Save the user document with the updated cart
    await user.save();

    res.json({ message: "Product added to cart successfully" });
  } catch (e) {
    console.error("Error:", e.message); // Log the error for debugging
    res.status(500).json({ error: e.message });
  }
});




//add product to cart
adminRouter.post("/admin/add-to-cart", admin ,async (req ,res) =>{
  try {
    const {id} =req.body;
    const product=await Product.findById(id);
    let user=await User.findById(req.user);
    
    let isProductFound=false;
    for(let i=0;i<user.cart.length ; i++){
      if(user.cart[i].product._id.equals(product._id)){
        isProductFound=true;
        console.log("Product is already added into cart!!!");
      }
    }

    if(!isProductFound)
      {
        user.cart.push({product});
      }

      user=await user.save();
      res.json(user);
  } catch (e) {
    
  }
})

// Get all your products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//get sub-category produts
adminRouter.get("/admin/products/", async (req, res) => {
  try {
    console.log(req.query.suCategory);
    const products = await Product.find({ subCategory: req.query.subCategory });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


adminRouter.get("/admin/products/from-cart", admin, async (req, res) => {
  try {
    const subCategory = req.query.subCategory;
    const userCart = await User.findOne({ _id: req.user.cart }); // Assuming the cart is associated with a user

    if (!userCart) {
      return res.status(404).json({ error: "User's cart not found" });
    }

    // Filter cart products based on subcategory
    const filteredProducts = userCart.cart.filter(item => item.product.subCategory === subCategory);

    res.json(filteredProducts);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});




// Delete the product from the user's cart
adminRouter.post("/admin/delete-cart-product", admin, async (req, res) => {
  try {
    const { userId, productId } = req.body;

    // Find the user
    let user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Remove the product from the user's cart
    user.cart = user.cart.filter(item => item.product._id.toString() !== productId);
    await user.save();

    res.json({ message: 'Product removed from cart successfully' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//admin get all orders
// Get all your products
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//change status
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



//update product details
adminRouter.post("/admin/update-product-details", admin, async (req, res) => {
  try {
    const { id, quantity, price, schedule } = req.body;
    let product = await Product.findById(id);
    product.quantity = quantity;
    product.price = price;
    product.schedule = schedule;
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//update details of products present in cart
adminRouter.post('/admin/update-cart-details', async (req, res) => {
  const { userId, productId, quantity, price, schedule } = req.body;

  console.log('Received userId:', userId);
  console.log('Received productId:', productId);
  console.log('Received quantity:', quantity);
  console.log('Received price:', price);
  console.log('Received schedule:', schedule);

  try {
    const user = await User.findById(userId);
    console.log('User:', user);

    if (!user) {
      return res.status(404).send({ message: 'User not found' });
    }

    console.log('User cart:', user.cart);

    let productInCart = user.cart.find(item => item.product && item.product._id.toString() === productId);
    console.log('Product in cart:', productInCart);

    if (productInCart) {
      productInCart.product.quantity = quantity; // Update quantity inside product object
      productInCart.product.price = price; // Update price
      productInCart.product.schedule = schedule; // Update schedule
      console.log('Updated product in cart:', productInCart);
      await user.save();
      res.json(user.cart);
    } else {
      res.status(404).json({ error: 'Product not found in cart' });
    }
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({ error: error.message });
  }
});



///fetch product by product is 
// Assuming your route is /admin/fetch-product-by-id
adminRouter.get("/admin/fetch-product-by-id/:productId", admin, async (req, res) => {
  try {
    const productId = req.params.productId;

    // Find product by productId in MongoDB
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    res.json(product); // Return the product details
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});




///earning analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    // CATEGORY WISE ORDER FETCHING
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}


//get product info by product id
adminRouter.get('/admin/get-product/:productId', admin, async (req, res) => {
  try {
    const product = await Product.findById(req.params.productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Get all your products
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = adminRouter;