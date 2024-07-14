const express = require("express");
const userRouter=express.Router();
const User=require("../models/user");
const auth=require("../middlewares/auth")
const { Product } = require("../models/product");
const { mongoose } = require("mongoose");
const Order = require("../models/order");
const moment = require('moment');

// userRouter.post("/admin/add-to-cart", auth ,async (req ,res) =>{
//   try {
//     const {id} =req.body;
//     const product=await Product.findById(id);
//     let user=await User.findById(req.user);
    
//     let isProductFound=false;
//     for(let i=0;i<user.cart.length ; i++){
//       if(user.cart[i].product._id.equals(product._id)){
//         isProductFound=true;
//         console.log("Product is already added into cart!!!");
//       }
//     }

//     if(!isProductFound)
//       {
//         user.cart.push({product});
//       }

//       user=await user.save();
//       res.json(user);
//   } catch (e) {
    
//   }
// })



//fetch products from other users cart
userRouter.get("/api/user/:userId/cart/products", auth, async (req, res) => {
    try {
      const user = await User.findById(req.params.userId).populate('cart.product');
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
      res.json(user.cart.map(item => item.product));
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  

// //fetch products from other users cart  and subcateegory   ////  but it is showing error so  we have used above 
//   userRouter.get("/api/user/:userId/cart/products/:subCategory", auth, async (req, res) => {
//     try {
//         const user = await User.findById(req.params.userId).populate('cart.product');
//         if (!user) {
//             return res.status(404).json({ error: "User not found" });
//         }
//         // Filter cart products by subcategory
//         const cartProducts = user.cart.filter(item => item.product.subCategory === req.params.subCategory).map(item => item.product);
//         res.json(cartProducts);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });




//copying / adding product to users cart by user
userRouter.post("/api/copy-product", async (req, res) => {
  try {
    const { productId, sourceUserId, targetUserId, quantity } = req.body;

    if (!mongoose.Types.ObjectId.isValid(targetUserId)) {
      return res.status(400).json({ error: "Invalid Target User ID format" });
    }

    if (!mongoose.Types.ObjectId.isValid(productId)) {
      return res.status(400).json({ error: "Invalid Product ID format" });
    }

    if (!mongoose.Types.ObjectId.isValid(sourceUserId)) {
      return res.status(400).json({ error: "Invalid Source User ID format" });
    }

    console.log(`Fetching source user with ID: ${sourceUserId}`);
    const sourceUser = await User.findById(sourceUserId);
    if (!sourceUser) {
      console.log(`Source user with ID: ${sourceUserId} not found`);
      return res.status(404).json({ error: "Source user not found" });
    }

    console.log(`Fetching product with ID: ${productId} from source user's cart`);
    const productInCart = sourceUser.cart.find(item => item.product && item.product._id.toString() === productId);
    if (!productInCart || !productInCart.product) {
      console.log(`Product with ID: ${productId} not found in source user's cart`);
      return res.status(404).json({ error: "Product not found in source user's cart" });
    }

    console.log(`Fetching target user with ID: ${targetUserId}`);
    const targetUser = await User.findById(targetUserId);
    if (!targetUser) {
      console.log(`Target user with ID: ${targetUserId} not found`);
      return res.status(404).json({ error: "Target user not found" });
    }

    // Check if the product already exists in the target user's cart
    const existingProductInTargetCart = targetUser.cart.find(item => item.product && item.product._id.toString() === productId);
    if (existingProductInTargetCart) {
      // If the product exists, update the quantity
      existingProductInTargetCart.quantity += quantity;
      console.log(`Updated product quantity in target user's cart: ${existingProductInTargetCart.quantity}`);
      await targetUser.save();
      res.json({ message: "Product quantity updated in cart", cartItem: existingProductInTargetCart });
    } else {
      // If the product doesn't exist, add it to the cart
      const cartItem = {
        product: productInCart.product,
        quantity,
      };
      targetUser.cart.push(cartItem);
      await targetUser.save();
      console.log(`Added new product to target user's cart`);
      res.json({ message: "Product added to cart successfully", cartItem });
    }
  } catch (e) {
    console.error(`Error: ${e.message}`);
    res.status(500).json({ error: e.message });
  }
});


//user placing order 
// userRouter.post("/api/order", auth, async (req, res) => {
//   try {
//     const { cart, totalPrice, address } = req.body;

//     if (!cart || cart.length === 0) {
//       return res.status(400).json({ msg: 'Cart is empty' });
//     }

//     let products = [];

//     for (let i = 0; i < cart.length; i++) {
//       const cartItem = cart[i];
//       const productId = cartItem.product._id;
//       console.log(`Fetching product with ID: ${productId}`); // Debug log

//       const product = await Product.findById(productId);

//       if (!product) {
//         console.error(`Product with ID: ${productId} not found`); // Debug log
//         return res.status(404).json({ msg: `Product with id ${productId} not found` });
//       }

//       console.log("Product Quantity",product.quantity);
//       console.log("cartItem  Quantity",cartItem.quantity);


//       if (product.quantity < cartItem.quantity) {
//         return res.status(400).json({ msg: `${product.name} is out of stock!` });
//       }

//       product.quantity -= cartItem.quantity;
//       products.push({ product: product._id, quantity: cartItem.quantity });
//       await product.save();
//     }

//     let user = await User.findById(req.user);
//     user.cart = [];
//     await user.save();

//     const order = new Order({
//       products,
//       totalPrice,
//       address,
//       userId: req.user,
//       orderedAt: new Date().getTime(),
//     });

//     await order.save();
//     res.json(order);

//   } catch (e) {
//     console.error(e.message); // Debug log
//     res.status(500).json({ error: e.message });
//   }
// });





userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address , instruction , tips , totalSave ,shopId} = req.body;

    if (!cart || cart.length === 0) {
      return res.status(400).json({ msg: 'Cart is empty' });
    }

    // Fetch the cart of the specific user
    const sourceUserId = '667c4e8e2f6dec6e82d1ada9';
    const sourceUser = await User.findById(sourceUserId);

    if (!sourceUser || !sourceUser.cart) {
      return res.status(404).json({ msg: 'Source user or cart not found' });
    }

    let products = [];

    for (let i = 0; i < cart.length; i++) {
      const cartItem = cart[i];
      const productId = cartItem.product._id;

      // Find the product in the source user's cart
      const sourceCartItem = sourceUser.cart.find(item => item.product._id.toString() === productId);

      if (!sourceCartItem) {
        return res.status(404).json({ msg: `Product with id ${productId} not found in source user's cart` });
      }

      if (sourceCartItem.product.quantity < cartItem.quantity) {
        return res.status(400).json({ msg: `${cartItem.product.name} is out of stock in the source user's cart!` });
      }

      sourceCartItem.product.quantity -= cartItem.quantity;

      // Fetch the full product details
      const product = await Product.findById(productId);

      if (!product) {
        return res.status(404).json({ msg: `Product with id ${productId} not found` });
      }

      // Check if the required fields are present
      if (!product.subCategory || !product.category) {
        return res.status(400).json({ msg: `Product with id ${productId} is missing required fields: subcategory or category` });
      }

      // Add the full product details to the order
      products.push({
        product: {
          _id: product._id,
          name: product.name,
          images: product.images,
          description: product.description,
          price: product.price,
          discountPrice: product.discountPrice,
          subCategory: product.subCategory,
          category: product.category,
        },
        quantity: cartItem.quantity,
      });

      await product.save();
    }

    // Save the updated source user's cart
    await sourceUser.save();

    let user = await User.findById(req.user);
    user.cart = [];
    await user.save();

    const order = new Order({
      products,
      totalPrice,
      shopId,
      totalSave,
      instruction,
      tips,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });

    await order.save();
    res.json(order);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Route to fetch products with not -null discountPrice from a user's cart
userRouter.get("/api/user/:userId/cart/products/nullDiscountPrice", auth, async (req, res) => {
  try {
      const user = await User.findById(req.params.userId).populate('cart.product');
      if (!user) {
          return res.status(404).json({ error: "User not found" });
      }

      // Filter cart products by null or zero discount price
      const cartProducts = user.cart.filter(item => item.product.discountPrice !== null || item.product.discountPrice !== 0).map(item => item.product);
      res.json(cartProducts);
  } catch (e) {
      res.status(500).json({ error: e.message });
  }
});





////quqntity increase
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//quqntity decresse
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//offer products
userRouter.get("/api/user/:userId/cart/products/offer", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.userId).populate('cart.product');
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Filter products based on the offer 'rain'
    const filteredProducts = user.cart
      .filter(item => item.product.offer === 'rain')
      .map(item => item.product);

    res.json(filteredProducts);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//fetch all orders based on shopId
//fetch all orders based on shopId
userRouter.get("/admin/get-orders", auth, async (req, res) => {
  try {
    const { shopId, date } = req.query;
    const startDate = moment(date).startOf('day').toDate();
    const endDate = moment(date).endOf('day').toDate();

    const orders = await Order.find({
      shopId,
      orderedAt: { $gte: startDate, $lte: endDate }
    });
    console.log("Fetched Orders: ", orders);

    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



module.exports=userRouter;