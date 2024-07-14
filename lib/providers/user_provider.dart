// import 'package:flutter/material.dart';
// import 'package:farm/models/user.dart';

// class UserProvider extends ChangeNotifier {
//   User _user = User(
//     id: '',
//     name: '',
//     email: '',
//     password: '',
//     address: '',
//     type: '',
//     token: '',
//     cart: [],
//   );

//   User get user => _user;

//   void setUser(String user) {
//     _user = User.fromJson(user);
//     notifyListeners();
//   }

//   void getUserData() {}

//   void setUserFromModel(User user) {
//     _user = user;
//     notifyListeners();
//   }
// }

import 'package:farm/models/order.dart';
import 'package:flutter/material.dart';
import 'package:farm/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void getUserData() {}

  void updateCart(List<Map<String, dynamic>> newCart) {
    _user = _user.copyWith(cart: newCart);
    notifyListeners();
  }
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void clearCart() {
    _user = _user.copyWith(cart: []);
    notifyListeners();
  }
}








class OrderProvider extends ChangeNotifier {
  Order _order = Order(
      id: '',
      quantity: [],
      instruction: [],
      userId: '',
      totalPrice: 0,
      tips: '',
      address: '',
      products: [],
      orderedAt: 0,
      status: 0, totalSave: 0, shopId: '') as Order;

  Order get order => _order;

  void setUser(String order) {
    _order = User.fromJson(order.toString()) as Order;
    notifyListeners();
  }

  void getUserData() {}

  void setUserFromModel(User order) {
    _order = order as Order;
    notifyListeners();
  }

  // void clearCart() {
  //   _order = _order.copyWith(products: []);
  //   notifyListeners();
  // }
}
