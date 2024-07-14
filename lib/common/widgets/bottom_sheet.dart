import 'package:flutter/material.dart';
import 'package:farm/features/admin/screens/cart_subtotal.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BottomSheet extends StatefulWidget {
  const BottomSheet({Key? key}) : super(key: key); // Fix the constructor syntax

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Add your bottom sheet content here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text('Option 1'),
                onTap: () {
                  // Handle option 1
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.album),
                title: Text('Option 2'),
                onTap: () {
                  // Handle option 2
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Sheet Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showBottomSheet,
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}







class BottomPage extends StatefulWidget {
  const BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {

  @override
  Widget build(BuildContext context) {
      final carts = context.watch<UserProvider>().user.cart;
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    height: 60,
                     color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('${carts.length}', style: TextStyle(color:Colors.white),),
                              Text('  Items added' ,style: TextStyle(fontSize: 16,color: Colors.white),), // replace with '${carts.length} Items added' if you have the carts variable
                              // CartSubtotal(), // Replace with your actual widget
                              Spacer(),
                              ElevatedButton(
                                style: ButtonStyle(
            elevation: MaterialStateProperty.all(0), // No elevation
            shadowColor: MaterialStateProperty.all(Colors.transparent), // No shadow color
            backgroundColor: MaterialStateProperty.all(Colors.green), // Green background color
          ),
                                
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Text('View cart', style: TextStyle(fontSize: 16 ,color: Colors.white),),
                                    
                                    IconButton(
                              onPressed: () {
                                // Add your back button onPressed logic here
                              },
                              icon: Transform.rotate(
                                angle: 180 * 3.14 / 180, // Convert degrees to radians for angle
                                child: Icon(Icons.arrow_back_ios , size: 18,),
                              ),
                            ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Text('Show Bottom Sheet'),
      ),
    );
  }
}
