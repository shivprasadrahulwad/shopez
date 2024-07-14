// import 'dart:convert';

// class Product {
//   final double? discountPrice;
//   final String? offer;
//   final String subCategory;
//   final String name;
//   final String description;
//   final double? quantity;  
//   final List<String> images;
//   // final List<String> scheduleOptions;
//   final String category;
//   final double price;
//   final String schedule;
//   final String? id;
  
//   Product({
//     required this.discountPrice,
//     required this.offer,
//     required this.subCategory,
//     required this.name,
//     required this.description,
//     required this.quantity,
//     required this.images,
//     // required this.scheduleOptions,
//     required this.category,
//     required this.price,
//     required this.schedule,
//     this.id,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'discountPrice': discountPrice,
//       // 'scheduleOptions': scheduleOptions,
//       'schedule' : schedule,
//       'offer' : offer,
//       'subCategory': subCategory,
//       'name': name,
//       'description': description,
//       'quantity': quantity,
//       'images': images,
//       'category': category,
//       'price': price,
//       'id': id,
//     };
//   }

//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       discountPrice: map['discountPrice']?.toDouble() ?? 0.0,
//       offer: map['offer'] ?? '',
//       subCategory: map['subCategory'] ?? '',
//       name: map['name'] ?? '',
//       description: map['description'] ?? '',
//       quantity: map['quantity']?.toDouble() ?? 0.0,
//       images: List<String>.from(map['images']),
//       // scheduleOptions: List<String>.from(map['scheduleOptions']),
//       category: map['category'] ?? '',
//       price: map['price']?.toDouble() ?? 0.0,
//       schedule: map['schedule'] ?? '',
//       id: map['_id'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
// }



import 'dart:convert';

class Product {
  final double? discountPrice;
  final String? offer;
  final String subCategory;
  final String name;
  final String description;
  final double? quantity;
  final List<String> images;
  final String category;
  final double price;
  final String schedule;
  final String? id;

  Product({
    required this.discountPrice,
    required this.offer,
    required this.subCategory,
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.schedule,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'discountPrice': discountPrice,
      'offer': offer,
      'subCategory': subCategory,
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'schedule': schedule,
      '_id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      discountPrice: map['discountPrice']?.toDouble(),
      offer: map['offer'],
      subCategory: map['subCategory'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble(),
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      schedule: map['schedule'] ?? '',
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
}
