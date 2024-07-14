import 'package:flutter/material.dart';

String uri = 'http://192.168.0.105:3000';

// const String google_api_key ="AIzaSyBbzSbqNS28snAxOWn4EMP5j9HW0jLNMYs";
class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const primaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const blueTextColor = Color(0xFF326BDC);
  static const lightBlueTextColor = Color.fromARGB(255, 115, 144, 189);
  static const savingColor = Color(0xFFDCE8FF);
  static const yelloColor = Color(0xFFfbcb44);
  static const lightGreen = Color(0xFFE9FFEE);
  static const greenColor = Color(0xFF328616);
  static const blueBackground = Color(0xFFdce8ff);
  static const backgroundColor = Color(0xFFF5F6FB);
  static const dividerColor = Color(0xFFE1E1E1);
  static const greyTextColor = Color.fromARGB(255, 125, 125, 125);
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static const faintBlackColor =  Color.fromARGB(255, 70, 70, 70);
  
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;
  static const cartFontWeight = FontWeight.bold;

  /////////////////////////////////////////////////////////////
  //providing source id from where products are fetched
  static const userId = '667c4e8e2f6dec6e82d1ada9';
  static const bagHandelingCharges = 10;

  static const List<String> carouselImages = [
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/farm/vpwpnauloikyllwymymj.jpg?_s=public-apps',
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/farm/p1d5wqzq1plbclov5wbh.jpg?_s=public-apps',
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/farm/vtegngurflbmk0cfmnl9.jpg?_s=public-apps',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'BreakFast',
      'image': 'images/breakfast.png',
    },
    {
      'title': 'Snacks',
      'image': 'images/food.png',
    },
    {
      'title': 'Drinks',
      'image': 'images/drinks.png',
    },
    {
      'title': 'Meal',
      'image': 'images/meal.png',
    },
  ];

  static const List<Map<String, dynamic>> vegetablesImages = [
    {
      'title': 'Vegetable',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862726/vegetables/pemi5bh4vugl4lc9p2ik.jpg',
      'sub-title': ['fruit', 'green','root'],
    },
    {
      'title': 'Fruits',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862726/vegetables/qaxf4tnkc2qcg3nxpain.jpg',
      'sub-title': ['Oil', 'Ghee', 'Masala', 'all'],
    },
    {
      'title': 'Cerels',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862726/vegetables/ecxelrsytjz5r6cxybuy.webp',
      'sub-title': ['Dry Fruits', 'Cereals', 'all'],
    },
    {
      'title': 'Flowers',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862727/vegetables/qdjkef2wfiuyu4v8igxz.jpg',
      'sub-title': ['Bakery', 'Biscuits', 'all'],
    },
    {
      'title': 'Milk Products',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862726/vegetables/fajcs7smdpvvddjcoe5p.webp',
      'sub-title': ['Biscuits', 'Bread', 'all'],
    },
    {
      'title': 'Ran-Meva',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720862726/vegetables/mokgv9ismpzyjheblzub.jpg',
      'sub-title': ['Sweets', 'Chocolates', 'all'],
    },
  ];

  

  static const List<Map<String, dynamic>> groceryAdminImages = [
    {
      'title': 'Atta, Rice & Dal',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Atta', 'Rice', 'Dal', "all"],
    },
    {
      'title': 'Oil, Ghee & Masala',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Oil', 'Ghee', 'Masala', 'all'],
    },
    {
      'title': 'Dry Fruits & Cereals',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Dry Fruits', 'Cereals', 'all'],
    },
    {
      'title': 'Bakery & Biscuits',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Bakery', 'Biscuits', 'all'],
    },
    {
      'title': 'Biscuits & Bread',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Biscuits', 'Bread', 'all'],
    },
    {
      'title': 'Sweets & Chocolates',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Sweets', 'Chocolates', 'all'],
    },
  ];

  static const List<Map<String, String>> beautyImages = [
    {
      'title': 'Bath & Body',
      'image': 'images/PaniPuri.png',
    },
    {
      'title': 'Skin & Face',
      'image': 'images/PaniPuri.png',
    },
    {
      'title': 'Feminine Hygiene',
      'image': 'images/PaniPuri.png',
    },
    {
      'title': 'Baby Care',
      'image': 'images/PaniPuri.png',
    },
  ];
}
