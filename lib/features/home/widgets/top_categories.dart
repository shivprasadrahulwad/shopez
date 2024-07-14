import 'package:farm/features/home/screens/fshop_products.dart';
import 'package:flutter/material.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/screens/fhome_screen.dart';
import 'package:farm/features/admin/screens/fshop_screen.dart';
import 'package:farm/features/admin/screens/shop_products.dart';
import 'package:farm/features/admin/screens/shop_screen.dart';
import 'package:farm/features/home/screens/category_deals_screen.dart';
import 'package:farm/models/product.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(left: 20 , right: 20),
        child: Row(
          children: List.generate(GlobalVariables.categoryImages.length, (index) {
            return GestureDetector(
              onTap: () => navigateToCategoryPage(
                context,
                GlobalVariables.categoryImages[index]['title']!,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        GlobalVariables.categoryImages[index]['image']!,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  Text(
                    GlobalVariables.categoryImages[index]['title']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).expand((widget) => [
            widget,
            const Spacer(), // Add a Spacer after each category
          ]).toList()..removeLast(), // Remove the last Spacer
        ),
      ),
    );
  }
}




// class RentTopCategories extends StatelessWidget {
//   const RentTopCategories({Key? key}) : super(key: key);

//   void navigateToCategoryPage(BuildContext context, String category) {
//     Navigator.pushNamed(context, CategoryDealsScreen.routeName,
//         arguments: category);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: Padding(
//         padding: EdgeInsets.only(left: 20 , right: 20),
//         child: Row(
//           children: List.generate(GlobalVariables.rentcategoryImages.length, (index) {
//             return GestureDetector(
//               onTap: () => navigateToCategoryPage(
//                 context,
//                 GlobalVariables.rentcategoryImages[index]['title']!,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child: Image.asset(
//                         GlobalVariables.rentcategoryImages[index]['image']!,
//                         fit: BoxFit.cover,
//                         height: 40,
//                         width: 40,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     GlobalVariables.rentcategoryImages[index]['title']!,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).expand((widget) => [
//             widget,
//             const Spacer(), // Add a Spacer after each category
//           ]).toList()..removeLast(), // Remove the last Spacer
//         ),
//       ),
//     );
//   }
// }


// class ShopProductsArguments {
//   final Map<String, dynamic> category;
//   final Product product;

//   ShopProductsArguments({
//     required this.category,
//     required this.product,
//   });
// }


class GroceryCategories extends StatelessWidget {
  const GroceryCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, Map<String, dynamic> category, String userId) {
    print('Navigating to ShopScreen with category: $category and userId: $userId');
    Navigator.pushNamed(
      context,
      ShopScreen.routeName,
      arguments: {
        'category': category,
        'userId': userId,
      },
    ); // Passing category details and userId when navigating
  }

  @override
  Widget build(BuildContext context) {
    // Example user ID; replace with the actual user ID retrieval method
    final userId = '12345'; // Replace this with the actual user ID from context or provider

    final List<List<Widget>> categoryRows = [];
    final chunkSize = 3;
    for (var i = 0; i < GlobalVariables.vegetablesImages.length; i += chunkSize) {
      final chunk = GlobalVariables.vegetablesImages.skip(i).take(chunkSize).toList();
      categoryRows.add(
        chunk.map((category) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(context, category, userId),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Change color as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      category['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                SizedBox(height: 4), // Add space between container and text
                Flexible(
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category['title']!,
                      style: const TextStyle(
                        fontSize: 12
                          ,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular'
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: categoryRows.map((row) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}




class Grocery extends StatelessWidget {
  final String userId; // Include userId in the Grocery class

  const Grocery({Key? key, required this.userId}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      ShopScreen.routeName,
      arguments: {
        'category': category,
        'userId': userId,
      },
    ); // Passing category details and userId when navigating
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> categoryRows = [];

    final chunkSize = 3;
    for (var i = 0; i < GlobalVariables.vegetablesImages.length; i += chunkSize) {
      final chunk = GlobalVariables.vegetablesImages.skip(i).take(chunkSize).toList();
      categoryRows.add(
        chunk.map((category) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(context, category),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Change color as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      category['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                SizedBox(height: 4), // Add space between container and text
                Flexible(
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category['title']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: categoryRows.map((row) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row,
              ),
            ),
          );
        }).toList(),
        
      ),
    );
  }
}





class BeautyCategories extends StatelessWidget {
    const BeautyCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(GlobalVariables.beautyImages.length, (index) {
            return GestureDetector(
              onTap: () => navigateToCategoryPage(
                context,
                GlobalVariables.beautyImages[index]['title']!,
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Change color as needed
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        GlobalVariables.beautyImages[index]['image']!,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 4), // Add space between container and text
                  Flexible(
                    child: Container(
                      width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        GlobalVariables.beautyImages[index]['title']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).expand((widget) => [
            widget,
            const Spacer(), // Add a Spacer after each category
          ]).toList()..removeLast(), // Remove the last Spacer
        ),
      ),
    );
  }
}




class Vegetables extends StatelessWidget {
  final String userId; // Include userId in the Grocery class

  const Vegetables({Key? key, required this.userId}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
   FShopScreen.routeName,
      arguments: {
        'category': category,
        'userId': userId,
      },
    ); // Passing category details and userId when navigating
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> categoryRows = [];

    final chunkSize = 3;
    for (var i = 0; i < GlobalVariables.vegetablesImages.length; i += chunkSize) {
      final chunk = GlobalVariables.vegetablesImages.skip(i).take(chunkSize).toList();
      categoryRows.add(
        chunk.map((category) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(context, category),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    // color: Colors.grey[400], // Change color as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      category['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    )
                  ),
                ),
                SizedBox(height: 4), // Add space between container and text
                Flexible(
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category['title']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Medium'
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: categoryRows.map((row) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row,
              ),
            ),
          );
        }).toList(),
        
      ),
    );
  }
}


