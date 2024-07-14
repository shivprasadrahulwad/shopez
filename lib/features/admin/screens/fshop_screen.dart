import 'package:farm/features/admin/screens/cart_subtotal.dart';
import 'package:flutter/material.dart';
import 'package:farm/common/widgets/add_button.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/screens/user_cart_products.dart';
import 'package:farm/features/home/service/home_services.dart';
import 'package:farm/models/product.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class FShopScreen extends StatefulWidget {
  static const String routeName = '/fshopScreen';
  final Map<String, dynamic> category;
  final String userId;

  const FShopScreen({Key? key, required this.category, required this.userId})
      : super(key: key);

  @override
  _FShopScreenState createState() => _FShopScreenState();
}

class _FShopScreenState extends State<FShopScreen> {
  int _page = 0;
  List<Product>? products;
  bool _isFloatingContainerOpen = false; // Track floating container state
  final HomeServices homeServices = HomeServices();

  bool _isItemDetailsOpen = false;
  List<Map<String, dynamic>> carts = [];

  @override
  void initState() {
    super.initState();
    fetchSubCategoryProducts();
    carts = context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
  }

  double calculateCartTotal(List<Map<String, dynamic>> cart) {
    int sum = 0;
    double require = 0;
    double deliveryPrice = 150;
    cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null && product != null) {
        final discountPrice = product['discountPrice'] as int?;
        final price = product['price'] as int;
        sum += quantity * (discountPrice ?? price);
        require = deliveryPrice - sum;
        require = (sum / deliveryPrice).toDouble();

        if (require > 1) {
          require = 1;
        }
      }
    });
    return require;
  }

  int addMore(List<Map<String, dynamic>> cart) {
    int sum = 0;
    int rem = 0;
    int require = 0;
    int deliveryPrice = 150;
    cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null && product != null) {
        final discountPrice = product['discountPrice'] as int?;
        final price = product['price'] as int;
        // sum += quantity * (discountPrice ?? price);
        sum += quantity * (discountPrice!);
        if (sum > deliveryPrice) {
          rem = 0;
        } else {
          rem = deliveryPrice - sum;
        }
      }
    });
    return rem;
  }

  void increaseQuantity(Product product) {
    homeServices
        .addToCart(
      context: context,
      product: product,
      quantity: 1, // Assuming you add one item at a time
    )
        .then((_) {
      setState(() {
        fetchSubCategoryProducts(); // Fetch updated products if needed
        carts = context
            .read<UserProvider>()
            .user
            .cart
            .cast<Map<String, dynamic>>(); // Update local cart state
        _isFloatingContainerOpen =
            true; // Ensure the floating container is open after adding an item
      });
    });
  }

  void decreaseQuantity(Product product) {
    homeServices
        .removeFromCart(
      context: context,
      product: product,
      sourceUserId: '',
    )
        .then((_) {
      setState(() {
        fetchSubCategoryProducts(); // Fetch updated products if needed
        carts = context
            .read<UserProvider>()
            .user
            .cart
            .cast<Map<String, dynamic>>(); // Update local cart state
        if (carts.isEmpty) {
          _isFloatingContainerOpen =
              false; // Close the floating container if the cart is empty
        }
      });
    });
  }

  fetchSubCategoryProducts() async {
    products = await homeServices.fetchCartProductsBySubCategory(
      context: context,
      userId: widget.userId,
      subCategory: widget.category['sub-title'][_page],
    );
    setState(() {});
  }

  Widget _buildProductList() {
    if (products != null) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two products in each row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: products!.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products![index]);
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 -
            10, // Set width of each item
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 130,
              width: 130, // Set a specific height for the image
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Image.network(
                      product.images.isNotEmpty ? product.images[0] : '',
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'SemiBold'),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.quantity?.toInt()}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Regular'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   product.description,
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.black,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '₹${(product.discountPrice?.toInt()).toString()}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'),
                          ),
                          Stack(
                            children: [
                              Text(
                                '₹${product.price?.toInt()}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    color: GlobalVariables.greyTextColor),
                              ),
                              const Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Divider(
                                  color: GlobalVariables
                                      .greyTextColor, // Choose your desired color
                                  thickness: 1, // Adjust thickness as needed
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // AddProduct(productId: product.id!),
                      AddCartButton(
                        productId: product.id!,
                        sourceUserId: '667c4e8e2f6dec6e82d1ada9',
                        // onAddToCart: () {
                        //   setState(() {
                        //     // Update UI when product is added to cart
                        //     fetchSubCategoryProducts();
                        //     carts = context
                        //         .read<UserProvider>()
                        //         .user
                        //         .cart
                        //         .cast<Map<String, dynamic>>();
                        //   });
                        // },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
      fetchSubCategoryProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final carts = context.watch<UserProvider>().user.cart;
    final carts =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    final percent = calculateCartTotal(carts);
    final rem = addMore(carts);

    // Toggle floating container state based on cart length
    if (carts.length >= 1 && !_isFloatingContainerOpen) {
      _isFloatingContainerOpen = true;
    }

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
                // IconButton(
                //   onPressed: () {
                //     // Handle shopping cart action
                //   },
                //   icon: const Padding(
                //     padding: EdgeInsets.only(top: 20),
                //     child: Icon(
                //       Icons.shopping_cart_outlined,
                //       color: GlobalVariables.greenColor,
                //       size: 20,
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     // Handle share action
                //     // Share.share('Your message here');
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.only(top: 30, right: 10),
                //     child: Text(
                //       'Share',
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: GlobalVariables.greenColor,
                //         fontFamily: 'SemiBold',
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '${widget.category['title']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: GlobalVariables.greenColor,
                    fontFamily: 'SemiBold',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.category['sub-title'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => updatePage(index),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                            color: _page == index
                                ? GlobalVariables.lightGreen
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _page == index
                                  ? GlobalVariables.greenColor
                                  : Colors.grey,
                            ),
                          ),
                          child: Text(
                            widget.category['sub-title'][index],
                            style: TextStyle(
                                color: _page == index
                                    ? GlobalVariables.greenColor
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: _buildProductList(),
              ),
              if(_isFloatingContainerOpen)
                Container(
                height: 130,
                color: GlobalVariables.backgroundColor,
              )
            ],
          ),
          if (_isFloatingContainerOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFloatingContainerOpen = false;
                  });
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20), // Rounded upper corners
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 0, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 228, 229, 239),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.list),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isItemDetailsOpen = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                '${carts.length}  ITEMS ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                backgroundColor: MaterialStateProperty.all(
                                    GlobalVariables.greenColor),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pushNamed(context, '/user-cart-products');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserCartProducts(
                                            totalPrice: 0,
                                            address: '',
                                            index: 0,
                                            tips: 0,
                                            instruction: [],
                                            totalSave: '',
                                            ShopId: '',
                                          )),
                                );
                                setState(() {
                                  _isFloatingContainerOpen = false;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Place order',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_isFloatingContainerOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFloatingContainerOpen = false;
                  });
                },
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20), // Rounded upper corners
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Column(children: [
                      Container(
                          decoration: const BoxDecoration(
                              color: GlobalVariables.blueBackground,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                top: 10),
                                            child: rem == 0
                                                ? const Icon(
                                                    Icons.motorcycle,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    size: 18,
                                                  )
                                                : const Icon(
                                                    Icons.shopping_cart,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    size: 18,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      rem == 0
                                          ? const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Yay! you got FREE Delivery",
                                                  style: TextStyle(
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    fontFamily: 'Regular',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'No coupons needed',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Regular',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Get FREE delivery ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    fontFamily: 'Medium',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   height: 5,
                                                // ),
                                                Text(
                                                  'Add products worth ${addMore(carts)} more',
                                                  style: const TextStyle(
                                                    fontFamily: 'Medium',
                                                    fontSize: 12,
                                                    color: GlobalVariables
                                                        .greyTextColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),

                                                Center(
                                                  child: LinearPercentIndicator(
                                                    lineHeight: 3,
                                                    barRadius:
                                                        const Radius.circular(
                                                            10),
                                                    width: 280,
                                                    animation: true,
                                                    animationDuration:
                                                        1000, // The duration is in milliseconds
                                                    percent: percent.toDouble(),
                                                    progressColor:
                                                        GlobalVariables
                                                            .yelloColor,
                                                    backgroundColor:
                                                        Colors.amber[50],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),

                                // const SizedBox(
                                //   height: 10,
                                // )
                              ])),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 228, 229, 239),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.timer,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isItemDetailsOpen = true;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${carts.length}  ITEMS ',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_up,
                                    color: GlobalVariables.greenColor,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    backgroundColor: MaterialStateProperty.all(
                                        GlobalVariables.greenColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.pushNamed(context, '/user-cart-products');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserCartProducts(
                                                totalPrice: 0,
                                                address: '',
                                                index: 0,
                                                tips: 0,
                                                instruction: const [],
                                                totalSave: '',
                                                ShopId: '',
                                              )),
                                    );
                                    setState(() {
                                      _isFloatingContainerOpen = false;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Place order',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: 'SemiBold',
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          if (_isItemDetailsOpen)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isItemDetailsOpen = false;
                      });
                    },
                    child: Container(
                      // height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20), // Rounded upper corners
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        color: GlobalVariables.blueBackground,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              left: 10,
                                                              right: 10,
                                                              top: 10),
                                                      child: rem == 0
                                                          ? const Icon(
                                                              Icons.motorcycle,
                                                              color: GlobalVariables
                                                                  .blueTextColor,
                                                              size: 18,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .shopping_cart,
                                                              color: GlobalVariables
                                                                  .blueTextColor,
                                                              size: 18,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                rem == 0
                                                    ? const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Yay! you got FREE Delivery",
                                                            style: TextStyle(
                                                              color: GlobalVariables
                                                                  .blueTextColor,
                                                              fontFamily:
                                                                  'Regular',
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            'No coupons needed',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Regular',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Get FREE delivery ",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: GlobalVariables
                                                                  .blueTextColor,
                                                              fontFamily:
                                                                  'Medium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // const SizedBox(
                                                          //   height: 5,
                                                          // ),
                                                          Text(
                                                            'Add products worth ${addMore(carts)} more',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Medium',
                                                              fontSize: 12,
                                                              color: GlobalVariables
                                                                  .greyTextColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),

                                                          Center(
                                                            child:
                                                                LinearPercentIndicator(
                                                              lineHeight: 3,
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(
                                                                      10),
                                                              width: 280,
                                                              animation: true,
                                                              animationDuration:
                                                                  1000, // The duration is in milliseconds
                                                              percent: percent
                                                                  .toDouble(),
                                                              progressColor:
                                                                  GlobalVariables
                                                                      .yelloColor,
                                                              backgroundColor:
                                                                  Colors.amber[
                                                                      50],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: GlobalVariables.dividerColor,
                                  ),
                                  ListView.separated(
                                    itemCount: carts.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      thickness: 1,
                                      color: GlobalVariables.dividerColor,
                                    ),
                                    itemBuilder: (context, index) {
                                      final productCart = carts[index];
                                      if (productCart['product'] == null) {
                                        return const SizedBox.shrink();
                                      }
                                      final product = Product.fromMap(
                                          productCart['product']);
                                      if (product == null) {
                                        return const SizedBox.shrink();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Image.network(
                                                    product.images.isNotEmpty
                                                        ? product.images[0]
                                                        : '',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Regular'),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        (product.quantity
                                                                ?.toInt())
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: GlobalVariables
                                                              .greyTextColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: GlobalVariables
                                                                            .greenColor,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: GlobalVariables
                                                                          .greenColor),
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () =>
                                                                        decreaseQuantity(
                                                                            product),
                                                                    child:
                                                                        Container(
                                                                      width: 25,
                                                                      height:
                                                                          25,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: GlobalVariables
                                                                              .greenColor,
                                                                          width:
                                                                              1.5),
                                                                      color: GlobalVariables
                                                                          .greenColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: 25,
                                                                      height:
                                                                          28,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        productCart['quantity']
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            fontFamily:
                                                                                'Medium',
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () =>
                                                                        increaseQuantity(
                                                                            product),
                                                                    child:
                                                                        Container(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '₹${(product.price).toInt()}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color: GlobalVariables
                                                                    .greyTextColor),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            '₹${(product.discountPrice)?.toInt()}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Regular',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )))
        ],
      ),
    );
  }
}
