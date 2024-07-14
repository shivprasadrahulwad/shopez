import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/screens/home_bar_graph.dart';
import 'package:farm/features/admin/screens/line_graph.dart';
import 'package:farm/features/home/service/home_services.dart';
import 'package:farm/models/order.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Order>? orders;
  double totalRevenue = 0;
  int totalOrders = 0;
  int uniqueCustomers = 0;
  List<int> weeklyOrders = List<int>.filled(7, 0); // Initialize with zeros
  int totalWeeklyOrders = 0;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchOrdersForToday('1234'); // Replace '1234' with your actual shopId
  }

  fetchOrdersForToday(String shopId) async {
    orders = await homeServices.fetchOrdersForToday(context, shopId);
    calculateRevenueAndOrders();
    calculateWeeklyOrders();
    setState(() {});
  }

  void calculateRevenueAndOrders() {
    totalRevenue = 0;
    totalOrders = 0;
    uniqueCustomers = 0;

    if (orders != null) {
      // Get today's date
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      DateTime endOfDay =
          DateTime(today.year, today.month, today.day, 23, 59, 59);

      // Filter orders by shopId '1234' and today's date
      List<Order> filteredOrders = orders!.where((order) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        return order.shopId == '1234' &&
            orderDate.isAfter(startOfDay) &&
            orderDate.isBefore(endOfDay);
      }).toList();

      totalOrders = filteredOrders.length;

      totalRevenue = filteredOrders.fold(0, (sum, order) {
        return sum + order.totalPrice;
      });

      Set<String> uniqueUserIds =
          filteredOrders.map((order) => order.userId).toSet();
      uniqueCustomers = uniqueUserIds.length;
    } else {
      print("No orders found.");
    }
  }

  // void calculateWeeklyOrders() {
  //   if (orders != null) {
  //     // Initialize a list to hold the count of orders for each day of the week
  //     List<int> ordersPerDay = List<int>.filled(7, 0);

  //     DateTime today = DateTime.now();
  //     DateTime startOfWeek = today.subtract(Duration(days: today.weekday % 7));

  //     for (var order in orders!) {
  //       DateTime orderDate =
  //           DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
  //       if (orderDate.isAfter(startOfWeek) &&
  //           orderDate.isBefore(today.add(Duration(days: 1)))) {
  //         int dayIndex = orderDate.weekday %
  //             7; // Convert weekday to index (0 = Sunday, 6 = Saturday)
  //         ordersPerDay[dayIndex]++;
  //       }
  //     }

  //     setState(() {
  //       weeklyOrders = ordersPerDay;
  //     });
  //   }
  // }

  void calculateWeeklyOrders() {
    if (orders != null) {
      // Initialize a list to hold the count of orders for each day of the week
      List<int> ordersPerDay = List<int>.filled(7, 0);
      int totalOrders = 0; // Initialize total orders counter

      // Get today's date and start of the current week
      DateTime today = DateTime.now();
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday % 7));

      // Iterate through orders and count orders for each day in the current week
      for (var order in orders!) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);

        // Check if order date is within the current week
        if (orderDate.isAfter(startOfWeek) &&
            orderDate.isBefore(today.add(const Duration(days: 1)))) {
          int dayIndex = orderDate.weekday %
              7; // Convert weekday to index (0 = Sunday, 6 = Saturday)
          ordersPerDay[dayIndex]++;
          totalOrders++;
        }
      }

      // Update state with the calculated weekly orders and total sum
      setState(() {
        weeklyOrders = ordersPerDay;
        totalWeeklyOrders = totalOrders;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          elevation: 0.0,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 15),
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, size: 25),
                      SizedBox(width: 10),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  )),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,
                      '/account'); // Replace '/account' with your actual route name for the AccountScreen
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 54, 47, 47),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: GlobalVariables.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // const Row(
                //   children: [
                //     Icon(Icons.dashboard, size: 30),
                //     SizedBox(width: 20),
                //     Text(
                //       'Dashboard',
                //       style: TextStyle(
                //         fontFamily: 'SemiBold',
                //         fontSize: 25,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Row(children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.greyTextColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.currency_rupee,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Today Revenue",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.greyTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      // Text(
                                      //   '₹',
                                      //   style: TextStyle(
                                      //     fontSize: 27,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                      Text(
                                        '${(totalRevenue.toInt()).toString()}',
                                        style: const TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFF82D2BA),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.arrow_outward,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '3.5%',
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Adds some space between the cards
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,
                              top: 10,
                              bottom: 10,),
                            child: Row(children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.greyTextColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_rounded,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total order",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.greyTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        totalOrders.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFF82D2BA),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.arrow_outward,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '3.5%',
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Adds some space between the cards
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,
                              top: 10,
                              bottom: 10,),
                            child: Row(children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.greyTextColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.people,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Customers",
                                    style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.greyTextColor),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        uniqueCustomers.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 30),
                                      Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFF82D2BA),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.arrow_outward,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '3.5%',
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Adds some space between the cards
                  ],
                ),
                Container(
                  height:
                      350, // Set a fixed height for the SalesChart container
                  child: const LineGraph(),
                ),
                Container(
                  height:
                      350, // Set a fixed height for the SalesChart container
                  child: HomeBarGraph(
                      weeklyOrders: weeklyOrders,
                      totalWeeklyOrders: totalWeeklyOrders),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
