// import 'package:flutter/material.dart';
// import 'package:farm/common/widgets/stars.dart';
// import 'package:farm/models/product.dart';

// class SearchedProduct extends StatelessWidget {
//   final Product product;
//   const SearchedProduct({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.network(
//               product.images[0],
//               height: 180,
//               width: 150,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 10),
//           // Product details column
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 20, left: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product name
//                   Text(
//                     product.shopName,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   // Product description
//                   Text(
//                     product.shopDescription,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   // Product price
//                   Text(
//                     '₹${product.price}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(top: 5,left: 5),
//                     child: Stars(rating: 4),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
