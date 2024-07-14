// import 'package:flutter/material.dart';
// import 'package:farm/common/widgets/add_button.dart';
// import 'package:farm/constants/global_variables.dart';
// import 'package:farm/models/product.dart';
// import 'package:farm/providers/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CartProducts extends StatefulWidget {
//   static const String routeName = '/cart-products';
//   final Map<String, dynamic> category;

//   const CartProducts({Key? key, required this.category}) : super(key: key);

//   @override
//   State<CartProducts> createState() => _CartProductsState();
// }

// class _CartProductsState extends State<CartProducts> {
//   int _page = 0;
//   List<Product>? products;

//   @override
//   void initState() {
//     super.initState();
//     fetchProductsFromCart(widget.category['sub-title'][_page]);
//   }

//   fetchProductsFromCart(String subCategory) async {
//     final userProvider = context.read<UserProvider>();
//     List<Product> productList = [];
//     try {
//       print('Fetching products for sub-category: $subCategory');
//       http.Response res = await http.get(
//         Uri.parse('$uri/admin/products/from-cart?subCategory=$subCategory'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': userProvider.user.token,
//         },
//       );
//       print('Response status code: ${res.statusCode}');
//       print('Response body: ${res.body}');

//       if (res.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(res.body);
//         for (var item in responseData) {
//           productList.add(Product.fromJson(item['product']));
//         }
//         setState(() {
//           products = productList;
//         });
//       } else {
//         throw Exception('Failed to fetch products');
//       }
//     } catch (e) {
//       print('Error occurred: $e');
//     }
//   }

//   Widget _buildProductList() {
//     if (products != null) {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Two products in each row
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.55,
//         ),
//         padding: const EdgeInsets.all(10),
//         itemCount: products!.length,
//         itemBuilder: (context, index) {
//           return _buildProductCard(products![index]);
//         },
//       );
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }

//   Widget _buildProductCard(Product product) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 2 - 10, // Set width of each item
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: 130, // Set a specific height for the image
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                 ),
//                 child: InkWell(
//                   onTap: () {},
//                   child: Image.asset(
//                     "images/PaniPuri.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.quantity,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.normal,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.description,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             '₹${product.discountPrice}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Stack(
//                             children: [
//                               Text(
//                                 '₹${product.price}',
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const Positioned(
//                                 left: 0,
//                                 right: 0,
//                                 bottom: 0,
//                                 child: Divider(
//                                   color: Colors.black, // Choose your desired color
//                                   thickness: 1, // Adjust thickness as needed
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       AddProduct(productId: product.id!), // Pass productId here
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void updatePage(int page) {
//     setState(() {
//       _page = page;
//       fetchProductsFromCart(widget.category['sub-title'][_page]);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(80),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: GlobalVariables.appBarGradient,
//             ),
//           ),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Padding(
//               padding: EdgeInsets.only(top: 20, left: 10),
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ),
//           title: Padding(
//             padding: const EdgeInsets.only(top: 30),
//             child: Text(
//               '${widget.category['title']}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 // Handle search action
//               },
//               icon: const Padding(
//                 padding: EdgeInsets.only(top: 20, right: 10),
//                 child: Icon(
//                   Icons.search_rounded,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 60,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: widget.category['sub-title'].length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => updatePage(index),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Chip(
//                       label: Text(
//                         widget.category['sub-title'][index],
//                         style: TextStyle(
//                           color: _page == index
//                               ? GlobalVariables.selectedNavBarColor
//                               : GlobalVariables.unselectedNavBarColor,
//                         ),
//                       ),
//                       backgroundColor: _page == index
//                           ? const Color.fromARGB(255, 160, 160, 160)
//                           : const Color.fromARGB(0, 170, 23, 23),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: _buildProductList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:farm/common/widgets/add_button.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/service/admin_services.dart';
import 'package:farm/models/product.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartProducts extends StatefulWidget {
  static const String routeName = '/cart-products';
  const CartProducts({Key? key}) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<UserProvider>().user.cart;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          elevation: 0.0,

          title: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.list),
              const Padding(
                padding: EdgeInsets.only(top: 4,left: 10),
                child: Text(
                  'Listed products',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => (),
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Container(
              color: GlobalVariables.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                          left: 10, right: 10),
                    child: Text(
                      'Total ${cart.length.toString()} products listed for sale',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Regular'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: cart.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.58,
                        ),
                        itemBuilder: (context, index) {
                          final productCart = cart[index];
                          final product =
                              Product.fromMap(productCart['product']);
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 130,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Image.network(
                                          product.images[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Regular'),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Rem. quantity: ${(product.quantity?.toInt())}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Regular'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        // Text(
                                        //   product.description,
                                        //   style: const TextStyle(
                                        //     fontSize: 14,
                                        //     color: Colors.black,
                                        //   ),
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                        // const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  '₹${product.discountPrice?.toInt()}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Stack(
                                                  children: [
                                                    Text(
                                                      '₹${product.price?.toInt()}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Regular',
                                                        color: GlobalVariables.greyTextColor
                                                      ),
                                                    ),
                                                    const Positioned(
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      child: Divider(
                                                        color: GlobalVariables.greyTextColor,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                DeleteProduct(
                                                  productId: product.id!,
                                                  onDelete: (productId) {
                                                    AdminServices()
                                                        .deleteProductFromCart(
                                                      context: context,
                                                      productId: productId,
                                                      onSuccess: () {
                                                        setState(() {
                                                          // Update UI after deletion
                                                          cart.removeAt(index);
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        EditButton(
                                          productId: product.id!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
