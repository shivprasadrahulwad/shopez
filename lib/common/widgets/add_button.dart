import 'package:farm/constants/global_variables.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:farm/constants/utils.dart';
import 'package:farm/features/admin/screens/fshop_products_detail_screen.dart';
import 'package:farm/features/admin/service/admin_services.dart';
import 'package:farm/features/home/service/home_services.dart';
import 'package:farm/models/product.dart';
import 'package:provider/provider.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 79, // Set width to match the parent's width
      height: 35,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                count++;
              });
            },
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // border: Border.all(color: Colors.green),
              ),
              child: const Icon(Icons.add, color: Colors.green , size: 12,),
            ),
          ),
          // Display "ADD" text or count based on the count value
          count == 0
              ? GestureDetector(
                onTap: () {
              setState(() {
                count++;
              });
            },
                child: const Text(
                    "ADD",
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              )
              : Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (count > 0) {
                  count--;
                }
              });
            },
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // border: Border.all(color: Colors.green),
              ),
              child: const Icon(Icons.remove, color: Colors.green  , size: 12,),
            ),
          ),
        ],
      ),
    );
  }
}






class AddProduct extends StatefulWidget {
  final String productId;

  const AddProduct({Key? key, required this.productId}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Future<Product?>? _futureProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _futureProduct = AdminServices().copyProductToAdminCart(
            context: context,
            productId: widget.productId,
          );
        });
      },
      child: Container(
        width: 60, // Set width to match the parent's width
        height: 30,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: GlobalVariables.greenColor),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "ADD",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.greenColor,
                fontFamily: 'SemiBold'
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class AddCartButton extends StatefulWidget {
  final String productId;
  final String sourceUserId;

  const AddCartButton({
    Key? key,
    required this.productId,
    required this.sourceUserId,
  }) : super(key: key);

  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  bool isInCart = false;

  @override
  Widget build(BuildContext context) {
    final carts =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    return GestureDetector(
      onTap: () {
        setState(() {
          isInCart = !isInCart;
          _addToCart(context, widget.productId, widget.sourceUserId, isInCart ? 1 : 0);
        });
      },
      child: Container(
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: GlobalVariables.greenColor),
        ),
        alignment: Alignment.center,
        child: Text(
          isInCart ? 'REM' : 'ADD',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SemiBold',
            color: GlobalVariables.greenColor,
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, String productId, String sourceUserId, int quantity) async {
    try {
      print('Updating cart: $productId, Source User ID: $sourceUserId, Quantity: $quantity');
      
      final homeServices = HomeServices();
      await homeServices.copyProductToUserCart(
        context: context,
        productId: productId,
        sourceUserId: sourceUserId,
        quantity: quantity,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}


class ViewButton extends StatefulWidget {
  final String productId;

  const ViewButton({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  _ViewButtonState createState() => _ViewButtonState();
}

class _ViewButtonState extends State<ViewButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FshopProductDetailsScreen(productId: widget.productId),
          ),
        );
      },
      child: Container(
        width: 79,
        height: 35,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.green),
        ),
        alignment: Alignment.center,
        child: Text(
          'View',
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}



class EditButton extends StatefulWidget {
  final String productId;

  const EditButton({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FshopProductDetailsScreen(productId: widget.productId),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: GlobalVariables.greenColor),
        ),
        alignment: Alignment.center,
        child: Text(
          'Edit',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SemiBold',
            color: GlobalVariables.greenColor,
          ),
        ),
      ),
    );
  }
}








class DeleteProduct extends StatelessWidget {
  final String productId;
  final Function(String) onDelete;

  const DeleteProduct({
    Key? key,
    required this.productId,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDelete(productId),
      child: Container(
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Color.fromARGB(255, 255, 0, 0)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Delete",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'SemiBold',
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// class EditProduct extends StatefulWidget {
//   final String productId;

//   const EditProduct({Key? key, required this.productId}) : super(key: key);

//   @override
//   _EditProductState createState() => _EditProductState();
// }

// class _EditProductState extends State<EditProduct> {
//   Future<RentProduct?>? _futureRentProduct;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _futureRentProduct = RentServices().copyProductToRentProduct(
//             context: context,
//             productId: widget.productId,
//           );
//         });
//       },
//       child: Container(
//         width: 79, // Set width to match the parent's width
//         height: 35,
//         padding: const EdgeInsets.all(4.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.0),
//           border: Border.all(color: Color.fromARGB(255, 255, 0, 0)),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               "Edit",
//               style: TextStyle(
//                 fontSize: 11.0,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 255, 0, 0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






class AddShopProduct extends StatefulWidget {
  final String productId;

  const AddShopProduct({Key? key, required this.productId}) : super(key: key);

  @override
  _AddShopProductState createState() => _AddShopProductState();
}

class _AddShopProductState extends State<AddShopProduct> {
  Future<Product?>? _futureProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FshopProductDetailsScreen(productId: '',)),
            );
      },
      child: Container(
        width: 79, // Set width to match the parent's width
        height: 35,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.green),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "ADD",
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
