// import 'package:flutter/material.dart';
// import 'package:farm/common/widgets/add_button.dart';
// import 'package:farm/common/widgets/loader.dart';
// import 'package:farm/features/admin/service/admin_services.dart';
// import 'package:farm/features/home/screens/best_sellers.dart';

// class CategoryDeals extends StatefulWidget {
//   const CategoryDeals({super.key});

//   @override
//   State<CategoryDeals> createState() => _CategoryDealsState();
// }

// class _CategoryDealsState extends State<CategoryDeals> {
//   List<Product>? products;
//   final AdminServices adminServices =AdminServices();

//  @override
// void initState() {
//   super.initState();
//   fetchAllProducts();
// }

// fetchAllProducts() async {
//   products = await adminServices.fetchAllProducts(context) as List<Product>?;
//   setState(() {});
// }

//   @override
//   Widget build(BuildContext context) {
//     return products ==null ? Loader() : Container(
//       color: Colors.grey[200],

//       child: GridView.count(crossAxisCount: 2 , childAspectRatio: 0.5,shrinkWrap: true,
//       children: [
//         for( int i=0 ;i<8 ;i++)

//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 255, 255, 255),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                 child: InkWell(
//                   onTap: () {},
//                   child: Image.asset("images/PaniPuri.png" ,height: 150,width: 150,),
//                 ),
//               ),

//               Container(
//                 padding: const EdgeInsets.only(  top: 10,left: 10 , right: 10),
//                 alignment: Alignment.centerLeft,
//                 child: const Text("Product Name is the main content off the product" ,maxLines: 2 , overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16 , color: Colors.black ,fontWeight:FontWeight.bold ),),
//               ),

//               Container(
//                 padding: const EdgeInsets.only(bottom: 8 , top: 10,left: 10 , right: 10),
//                 alignment: Alignment.centerLeft,
//                 child: const Text("5 Kg" , style: TextStyle(fontSize: 14 , color: Colors.black ,fontWeight:FontWeight.normal ),),
//               ),

//               const Padding(
//                 padding: EdgeInsets.only(left: 10 ,right: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("₹388"),
//                     AddProduct  (),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         )
//       ],),
//     );
//   }
// }

import 'package:farm/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:farm/common/widgets/horizontal_line.dart';
import 'package:farm/common/widgets/loader.dart';
import 'package:farm/features/admin/service/admin_services.dart';
import 'package:farm/features/home/widgets/carousel_image.dart';
import 'package:farm/features/home/widgets/top_categories.dart';
import 'package:farm/models/product.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CategoryDeals extends StatefulWidget {
  const CategoryDeals({Key? key}) : super(key: key);

  @override
  State<CategoryDeals> createState() => _CategoryDealsState();
}

class _CategoryDealsState extends State<CategoryDeals> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return 
         Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          elevation: 0.0,

          title: const Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                  Icons.category,
                  color: Colors.black,
                  size: 25,
                ),

                SizedBox(width: 20,),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'SemiBold',
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
          child: Column(
            children: [
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  //             image: DecorationImage(
                  //   image: AssetImage("images/canva.png"),
                  //   fit: BoxFit.cover,
                  // ),
                  // color:
                  //     Colors.grey.withOpacity(0.4), // Set background color here
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20) ,bottomRight: Radius.circular(20)), // Adjust border radius as needed
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const AddressBox(),
                      // const SizedBox(height: 10,),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                // onFieldSubmitted: navigateToSearchScreen,
                                decoration: const InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.only(top: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    // borderSide: BorderSide.none,
                                    borderSide: BorderSide(
                                      // Adjust this line to specify border color and width
                                      color: Colors
                                          .black38, // Change the color to make the border visible
                                      width: 1, // Adjust the width as needed
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                  ),
                                  hintText: "Search 'Vegetables'",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CarouselImage(),
                    ],
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 20, top: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Bestsellers",
              //         style: TextStyle(
              //           fontSize: 16, // Adjust font size as needed
              //           fontWeight:
              //               FontWeight.bold, // Adjust font weight as needed
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       HorizontalLine(),
              //     ],
              //   ),
              // ),
      
              // BestSellers(),
              
              // const TopCategories(),
              // const SizedBox(height: 10),
              // const SizedBox(height: 10),
              // const RentTopCategories(),
            //  GrocerySubCategories(subCategories: GlobalVariables.groceryImages),
      
      
              // const SizedBox(height: 10),
              // const Padding(
              //   padding: EdgeInsets.only(left: 20, top: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Offer Price",
              //         style: TextStyle(
              //           fontSize: 16, // Adjust font size as needed
              //           fontWeight:
              //               FontWeight.bold, // Adjust font weight as needed
              //         ),
              //       ),
              //       SizedBox(width: 10), // Add spacing between text and divider
              //       HorizontalLine(),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // OfferProducts(),
              const SizedBox(height: 20),
              // GrocerySubCategories(),
              // const SizedBox(height: 20),
              // const TopCategories(),
              // const SizedBox(height: 20),
              const Text("Category",style: TextStyle(fontFamily: 'SemiBold',fontWeight: FontWeight.bold,fontSize: 16),),
              const HorizontalLine(),
              const SizedBox(height: 20),
              const GroceryCategories(),
              const SizedBox(height: 20),
              // const Text("Beauty & Personal Care"),
              // const HorizontalLine(),
              // const SizedBox(height: 20),
              // const BeautyCategories(),
              const SizedBox(height: 20),
              // const Text("Snacks"),
              const SizedBox(height: 20),
              // OfferProducts(),

              Container(
                height: 300,
                color: GlobalVariables.backgroundColor,
                child: 
                const Padding(
                  padding: EdgeInsets.only(top: 30 ,left: 30 ,right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //             height: 50,
                      //           ),
                                Center(
                                  child: Text(
                                    "India's  Farmer connector app",
                                    style: TextStyle(
                                        fontFamily: 'SemiBold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: GlobalVariables.lightBlueTextColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                HorizontalLine1(),
                                SizedBox(height: 25,),
                                Center(
                                  child: Text(
                                    'farcon',
                                    style: TextStyle(
                                        fontFamily: 'SemiBold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color:
                                            GlobalVariables.lightBlueTextColor),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'V14.127.3',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: showNotification,
      //   child: const Icon(Icons.notification_add),
      // ),
    );
  }
}
