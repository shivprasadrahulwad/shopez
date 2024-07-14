import 'package:farm/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm/common/widgets/loader.dart';
import 'package:farm/features/admin/service/admin_services.dart';
import 'package:farm/features/home/screens/order_details_screen.dart';
import 'package:farm/models/order.dart';



class OrdersScreen extends StatefulWidget {
  final String shopId;

  const OrdersScreen({Key? key, required this.shopId}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    if (orders != null) {
      // Filter orders by shopId and status < 3
      orders = orders!.where((order) => order.shopId == widget.shopId && order.status < 3).toList();

      // First, sort by date and time in ascending order
      orders!.sort((a, b) {
        // Convert milliseconds since epoch to DateTime
        DateTime dateA = DateTime.fromMillisecondsSinceEpoch(a.orderedAt);
        DateTime dateB = DateTime.fromMillisecondsSinceEpoch(b.orderedAt);

        // Compare dates
        int dateComparison = dateA.compareTo(dateB);

        // If dates are the same, compare times
        if (dateComparison != 0) {
          return dateComparison; // Sort by date
        } else {
          return a.orderedAt
              .compareTo(b.orderedAt); // Sort by time if dates are the same
        }
      });

      print('Fetched ${orders!.length} orders'); // Debug print
      for (var order in orders!) {
        print('Order ID: ${order.id}, OrderedAt: ${order.orderedAt}');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          elevation: 0.0,
          
          actions: const [
            Row(
              children: [],
            ),
          ],
          title: const Padding(
            padding: EdgeInsets.only(left: 10 ,top: 18 ,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shopping_bag),
                SizedBox(width: 10,),
               Padding(
                padding: EdgeInsets.only(top: 3),
                 child: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.bold
                      ),
                    ),
               ),
              ],
            ),
          ),
        ),
      ),
      body: orders == null
          ? const Loader()
          : ListView.builder(
              itemCount: orders!.length,
              itemBuilder: (context, index) {
                final orderData = orders![index];
                final orderDate =
                    DateTime.fromMillisecondsSinceEpoch(orderData.orderedAt);
                final formattedDate =
                    DateFormat('dd MMM yyyy, hh:mm a').format(orderDate);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      OrderDetailScreen.routeName,
                      arguments: orderData,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          16), // Adjust the radius as needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${orderData.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: GlobalVariables.greyTextColor,
                              fontSize: 12

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
