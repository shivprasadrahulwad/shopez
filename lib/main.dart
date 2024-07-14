import 'package:farm/common/widgets/bottom_bar.dart';
import 'package:farm/common/widgets/home_splash_scren.dart';
import 'package:farm/common/widgets/splash_screen.dart';
import 'package:farm/constants/global_variables.dart';
import 'package:farm/features/admin/screens/cart_products.dart';
import 'package:farm/features/admin/screens/fhome_screen.dart';
import 'package:farm/features/admin/screens/fproduct_detail_screen.dart';
import 'package:farm/features/admin/screens/fshop_products_detail_screen.dart';
import 'package:farm/features/auth/screens/auth_screen.dart';
import 'package:farm/features/auth/services/auth_service.dart';
import 'package:farm/features/home/screens/home_screen.dart';
import 'package:farm/providers/user_provider.dart';
import 'package:farm/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';



final FlutterLocalNotificationsPlugin notificationsPlugin =FlutterLocalNotificationsPlugin();

void main() async {

   WidgetsFlutterBinding.ensureInitialized();

  // initializeTimeZones();

  AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings
  );

  bool? initialized = await notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      // log(response.payload.toString());
    }
  );

  // log("Notifications: $initialized");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'farcon',
  theme: ThemeData(
    scaffoldBackgroundColor: GlobalVariables.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: GlobalVariables.secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    fontFamily: 'Poppins', // Add the font family here
  ),
  onGenerateRoute: (settings) => generateRoute(settings),
  home: 
  // MapPage(),
  // Provider.of<UserProvider>(context).user.token.isNotEmpty
  //     ? Provider.of<UserProvider>(context).user.type == 'user'
  //         ? const BottomBar()
  //         : const AdminScreen()
          
  //     : const AuthScreen(),


  Consumer<UserProvider>(
  builder: (context, userProvider, _) {
    if (userProvider.user.token.isNotEmpty) {
      return userProvider.user.type == 'user'
          ? const HomeSplashScreen()
          : userProvider.user.type == 'admin'
              ? const AdminBottomBar()
              // const CategoryDeals()
              // : userProvider.user.type == 'rent'
              //     ? const AdminAccommodationScreen()
                  : const AuthScreen();
    } else {
      return SplashScreen();
    }
  },
),

);

  }
}