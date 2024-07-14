import 'package:farm/common/widgets/custom_buttons.dart';
import 'package:farm/common/widgets/sinwave_horizontal_line.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/screens/bills_details.dart';
import 'package:farm/features/admin/screens/cart_subtotal.dart';
import 'package:farm/features/admin/service/admin_services.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:farm/models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order? order;

  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  late int subTotal;

  @override
  void initState() {
    super.initState();
    final cart =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    if (widget.order != null) {
      currentStep = widget.order!.status;
      changeOrderStatus(
                                          currentStep);
                                    ;
    }
  }

  void changeOrderStatus(int status) {
    if (widget.order != null) {
      adminServices.changeOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order!,
        onSuccess: () {
          setState(() {
            currentStep = (currentStep + 1).clamp(0, 3);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    int handelingCahrge = 10;
    int grandTotal = widget.order!.totalPrice + handelingCahrge;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          actions: const [
            Row(
              children: [

              ],
            ),
          ],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Your Orders',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.order == null
          ? const Center(
              child: Text(
                'NO Order yet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'View order details',
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text(
                                    "Bill details",
                                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '-  ${DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                   style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        
                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Text('ID: ${widget.order!.id}',style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        
                        color: Colors.black),),
                                  const Spacer(),
                                  Text(
                                    'Time: ${DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        
                        color: Colors.black),
                                  ),
                                ],
                              ),
                              
                            ),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item' ,style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    'Price(1 Q.)',
                                    style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor),
                                  ),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: widget.order!.products.isEmpty
                                      ? [
                                          const Center(
                                            child: Text(
                                              'No products in this order.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]
                                      : widget.order!.products.map((product) {
                                          int index = widget.order!.products
                                              .indexOf(product);
                                          return Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Regular'),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // const Spacer(),
                                                    Text(
                                                      (product.price.toInt())
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Regular'),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    
                                                    
                                                    // const Spacer(),
                                                    Text(
                                                      '${widget.order!.quantity[index]}',
                                                      style: const TextStyle(
                                                        fontFamily: 'Regular',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 25,)
                                            ],
                                          );
                                        }).toList(),
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  const Icon(Icons.event_note_sharp,size: 18,),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Sub Total",
                                    style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  // CartSubtotal(),
                                  Text('₹${widget.order!.totalPrice}',
                                      style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_bag_rounded,size: 18,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Handeling Charge",
                                    style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor),
                                  ),
                                  Spacer(),
                                  Text("₹10",
                                     style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular',color: GlobalVariables.faintBlackColor)),
                                ],
                              ),
                            ),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 20, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Grand Total",
                                    style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,fontFamily: 'Regular')
                                  ),
                                  Spacer(),
                                  CartTotal(),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                ClipPath(
                                  clipper: SineWaveClipper(
                                    amplitude: 3,
                                    frequency: 15,
                                  ),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(),
                                    child: Container(
                                      width: double.infinity,
                                      height: 70, // Adjust the height as needed

                                      decoration: const BoxDecoration(
                                          color: GlobalVariables.savingColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Positioned(
                                            top:
                                                19, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total savings",
                                                  style:
                              TextStyle(fontSize: 14, color: GlobalVariables.blueTextColor, fontWeight: FontWeight.bold ,fontFamily: 'Regular',),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top:
                                                35, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Includes 150 savings through free delivery",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: GlobalVariables
                                                          .lightBlueTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹${widget.order!.totalSave+150
                                        }',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.blueTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.black12,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Order Time: ${DateFormat('hh:mm a').format(
                    //           DateTime.fromMillisecondsSinceEpoch(
                    //               widget.order!.orderedAt),
                    //         )}',
                    //       ),
                    //       Text('Order ID: ${widget.order!.id}'),
                    //       Text('Order Total: \₹${widget.order!.totalPrice}'),
                    //       const SizedBox(height: 10),
                    //       const Text(
                    //         'Purchase Details',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 10),

                    Card(
                      elevation:
                          4, // You can adjust the elevation to add shadow depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Setting border radius to 20
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Optional: Add padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Track order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SemiBold'
                              ),
                            ),
                            const SizedBox(
                                height:
                                    16.0), // Optional: Add space between text and Stepper
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(
                                    20.0), // Ensure Container matches Card's border radius
                              ),
                              child: Stepper(
                                currentStep: currentStep,
                                controlsBuilder: (context, details) {
                                  if (user.type == 'admin' && currentStep < 3) {
                                    return CustomButton(
                                      text: 'Done',
                                      onTap: () => changeOrderStatus(
                                          details.currentStep),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                steps: [
                                  Step(
                                    title: const Text('Pending',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),),
                                    content: const Text(
                                      'Your order is yet to be accepted',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),
                                    ),
                                    isActive: currentStep > 0,
                                    state: currentStep > 0
                                        ? StepState.complete
                                        : StepState.indexed,
                                  ),
                                  Step(
                                    title: const Text('Accepted',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),),
                                    content: const Text(
                                      'Your order has been accepted',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),
                                    ),
                                    isActive: currentStep > 1,
                                    state: currentStep > 1
                                        ? StepState.complete
                                        : StepState.indexed,
                                  ),
                                  Step(
                                    title: const Text('Ready to pickup',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),),
                                    content: const Text(
                                      'Your order has been ready to pickup',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),
                                    ),
                                    isActive: currentStep > 2,
                                    state: currentStep > 2
                                        ? StepState.complete
                                        : StepState.indexed,
                                  ),
                                  Step(
                                    title: const Text('Received',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),),
                                    content: const Text(
                                      'Your order has been picked and signed by you!',style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'
                              ),
                                    ),
                                    isActive: currentStep >= 3,
                                    state: currentStep >= 3
                                        ? StepState.complete
                                        : StepState.indexed,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
