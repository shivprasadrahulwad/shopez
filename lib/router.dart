import 'package:farm/features/home/screens/fshop_products.dart';
import 'package:flutter/material.dart';
import 'package:farm/common/widgets/bottom_bar.dart';
import 'package:farm/features/account/screens/account_screen.dart';
import 'package:farm/features/admin/screens/cart_products.dart';
import 'package:farm/features/admin/screens/fshop_screen.dart';
import 'package:farm/features/admin/screens/shop_products.dart';
import 'package:farm/features/admin/screens/shop_screen.dart';
import 'package:farm/features/admin/screens/user_cart_products.dart';
import 'package:farm/features/auth/screens/auth_screen.dart';
import 'package:farm/features/auth/screens/signup_screen.dart';
import 'package:farm/features/home/screens/about_us.dart';
import 'package:farm/features/home/screens/account_privacy.dart';
import 'package:farm/features/home/screens/category_deals_screen.dart';
import 'package:farm/features/home/screens/home_screen.dart';
import 'package:farm/features/home/screens/order_details_screen.dart';
import 'package:farm/models/order.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch(routeSettings.name){
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );

    // case HomeScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) =>  HomeScreen(),
    //   );

      case AccountPrivacy.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  const AccountPrivacy(),
      );

      case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  const AccountScreen(),
      );

      case AboutUs.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  const AboutUs(),
      );

    // case RentScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) =>  RentScreen(),
    //   );  

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    // case AddProductScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const AddProductScreen(),
    //   );

    // case AddProductScreenAdmin.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const AddProductScreenAdmin(),
    //   );

    // case RentAddProductScreenAdmin.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const RentAddProductScreenAdmin(),
    //   );  

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );

    case ShopProducts.routeName:
  var category = routeSettings.arguments as Map<String, dynamic>; // Correctly cast to a map
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => ShopProducts(
      category: category,
    ),
  );

  case fshopProducts.routeName:
  var category = routeSettings.arguments as Map<String, dynamic>; // Correctly cast to a map
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => const fshopProducts()
  );



 case ShopScreen.routeName:
      var args = routeSettings.arguments as Map<String, dynamic>?;
      if (args == null) {
        print('Error: Arguments are null for ShopScreen');
        return _errorRoute('Arguments are null for ShopScreen');
      }
      var category = args['category'];
      var userId = args['userId'];
      
      if (category == null || userId == null) {
        print('Error: Category or userId is null');
        return _errorRoute('Category or userId is null');
      }

      print('Navigating to ShopScreen with category: $category and userId: $userId');
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ShopScreen(
          category: category
        ),
      );


  case FShopScreen.routeName:
  var args = routeSettings.arguments as Map<String, dynamic>; // Assuming arguments contain both category and userId
  var category = args['category']; // Extracting category from arguments
  var userId = args['userId']; // Extracting userId from arguments
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => FShopScreen(
      category: category,
      userId: userId, // Pass userId to ShopScreen
    ),
  );


   case CartProducts.routeName:
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => const CartProducts(),
  );

   case OrderDetailScreen.routeName:
   var order=routeSettings.arguments as Order;
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => OrderDetailScreen(order: order),
  );


case UserCartProducts.routeName:
  var args = routeSettings.arguments as Map<String, dynamic>;
  var totalPrice = int.parse(args['totalPrice']);
  var totalSave = args['totalSave'];
  var address = args['address'];
  var shopId = args['shopId'];
  var index = args['index'] as int; // Assuming 'index' is passed as an int
  var instruction = args['instruction'] as List<Map<String, String>>;
  var tips = args['tips'] as int; // Assuming 'index' is passed as an int

  return MaterialPageRoute(
    settings: routeSettings,
    builder: (_) => UserCartProducts(totalPrice: totalPrice, address: address, index: index, instruction: instruction ?? [], tips: 0, totalSave: '', ShopId: '',),
  );






      
    case RentCategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => RentCategoryDealsScreen(
          category: category,
        ),
      );          
      
    // case SearchScreen.routeName:
    //   var searchQuery = routeSettings.arguments as String;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => SearchScreen(
    //       searchQuery: searchQuery,
    //     ),
    //   );

    //   case ProductDetailScreen.routeName:
    //   var product = routeSettings.arguments as Product;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => ProductDetailScreen(
    //       shopId: product.shopId,
    //       product: product,
    //     ),
    //   );

    //   case MessDetailScreen.routeName:
    //   var product = routeSettings.arguments as Product;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => MessDetailScreen(
    //       product: product,
    //     ),
    //   );

    default: 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen Dosen't Exist !!!"),
          ),
        ),
      );  
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Error: $message'),
      ),
    ),
  );
}