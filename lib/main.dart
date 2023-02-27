import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

import 'config/colors.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

import './providers/product_provider.dart';
import './providers/cart_provider.dart';
import 'providers/auth.dart';
import 'providers/order_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (context) => ProductProvider('', [], ''),
          update: (context, auth, previousNotifier) => ProductProvider(
            auth.token ?? '', //to avoid null error
            previousNotifier == null ? [] : previousNotifier.items,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order('', [], ''),
          update: (context, auth, previousNotifier) => Order(
            auth.token ?? '', //to avoid null error
            previousNotifier == null ? [] : previousNotifier.orders,
            auth.userId,
            // previousNotifier!.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, authObj, child) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColor.purple,
                secondary: AppColor.peach,
              ),
            ),
            // home: const ProductsOverviewScreen(),
            home: authObj.isAuth
                ? const ProductsOverviewScreen()
                : LoginTry(
                    auth: authObj,
                  ),
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}

class LoginTry extends StatelessWidget {
  final Auth auth;
  const LoginTry({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
