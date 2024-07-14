import 'package:flutter/material.dart';
import 'package:farm/common/widgets/loader.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/home/widgets/address_box.dart';
import 'package:farm/features/search/services/search_services.dart';
import 'package:farm/features/search/widget/searched_product.dart';
import 'package:farm/models/product.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
  }

  fetchSearchedProduct() async {
    products = await searchServices.fetchSearchedProduct(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Products',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   color: Colors.transparent,
              //   height: 42,
              //   margin: const EdgeInsets.symmetric(horizontal: 10),
              //   child: const Icon(Icons.mic, color: Colors.black, size: 25),
              // ),
            ],
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : Column(
              children: [
                const AddressBox(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   ProductDetailScreen.routeName,
                          //   arguments: products![index],
                          // );
                        },
                        // child: SearchedProduct(
                        //   product: products![index],
                        // )
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}



// // import 'package:flutter/material.dart';
// // import 'package:farm/common/widgets/loader.dart';
// // import 'package:farm/constants/global_variables.dart';
// // import 'package:farm/features/home/widgets/address_box.dart';
// // import 'package:farm/features/search/services/search_services.dart';
// // import 'package:farm/features/search/widget/searched_product.dart';
// // import 'package:farm/models/product.dart';
// // import 'dart:async';


// // class SearchScreen extends StatefulWidget {
// //   static const String routeName = '/search-screen';
// //   final String searchQuery;
// //   const SearchScreen({
// //     Key? key,
// //     required this.searchQuery,
// //   }) : super(key: key);

// //   @override
// //   State<SearchScreen> createState() => _SearchScreenState();
// // }


// // Stream<String> hintStream() async* {
// //   while (true) {
// //     yield "Search for 'dishes'";
// //     await Future.delayed(Duration(seconds: 2));
// //     yield "Search for 'Icecream'";
// //     await Future.delayed(Duration(seconds: 2));
// //     yield "Search for 'Cake'";
// //     await Future.delayed(Duration(seconds: 2));
// //   }
// // }


// // class _SearchScreenState extends State<SearchScreen> {
// //   List<Product>? products;
// //   final SearchServices searchServices = SearchServices();
// //   late Stream<String> _hintStream;
// //   late StreamSubscription<String> _hintSubscription;
// //   String currentHint = "Search for 'dishes'";

// //   @override
// //   void initState() {
// //     super.initState();
// //     _hintStream = hintStream();
// //     _hintSubscription = _hintStream.listen((hint) {
// //       setState(() {
// //         currentHint = hint;
// //       });
// //     });
// //     fetchSearchedProduct();
// //   }

// //   @override
// //   void dispose() {
// //     _hintSubscription.cancel();
// //     super.dispose();
// //   }

// //   fetchSearchedProduct() async {
// //     products = await searchServices.fetchSearchedProduct(
// //       context: context,
// //       searchQuery: widget.searchQuery,
// //     );
// //     setState(() {});
// //   }

// //   void navigateToSearchScreen(String query) {
// //     Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: PreferredSize(
// //         preferredSize: const Size.fromHeight(60),
// //         child: AppBar(
// //           flexibleSpace: Container(
// //             decoration: const BoxDecoration(
// //               gradient: GlobalVariables.appBarGradient,
// //             ),
// //           ),
// //           title: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 child: Container(
// //                   height: 42,
// //                   margin: const EdgeInsets.only(left: 15),
// //                   child: Material(
// //                     borderRadius: BorderRadius.circular(7),
// //                     elevation: 1,
// //                     child: TextFormField(
// //                       onFieldSubmitted: navigateToSearchScreen,
// //                       decoration: InputDecoration(
// //                         prefixIcon: InkWell(
// //                           onTap: () {},
// //                           child: const Padding(
// //                             padding: EdgeInsets.only(
// //                               left: 6,
// //                             ),
// //                             child: Icon(
// //                               Icons.search,
// //                               color: Colors.black,
// //                               size: 23,
// //                             ),
// //                           ),
// //                         ),
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         contentPadding: const EdgeInsets.only(top: 10),
// //                         border: const OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(
// //                             Radius.circular(7),
// //                           ),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         enabledBorder: const OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(
// //                             Radius.circular(7),
// //                           ),
// //                           borderSide: BorderSide(
// //                             color: Colors.black38,
// //                             width: 1,
// //                           ),
// //                         ),
// //                         hintText: currentHint,
// //                         hintStyle: const TextStyle(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 17,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 color: Colors.transparent,
// //                 height: 42,
// //                 margin: const EdgeInsets.symmetric(horizontal: 10),
// //                 child: const Icon(Icons.mic, color: Colors.black, size: 25),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: products == null
// //           ? const Loader()
// //           : Column(
// //               children: [
// //                 const AddressBox(),
// //                 const SizedBox(height: 10),
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: products!.length,
// //                     itemBuilder: (context, index) {
// //                       return GestureDetector(
// //                         onTap: () {
// //                           // Navigator.pushNamed(
// //                           //   context,
// //                           //   ProductDetailScreen.routeName,
// //                           //   arguments: products![index],
// //                           // );
// //                         },
// //                         child: SearchedProduct(
// //                           product: products![index],
// //                         )
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //     );
// //   }
// // }
