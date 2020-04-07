import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_again/helpers/custom_route.dart';
import 'package:shop_app_again/providers/auth.dart';
import 'package:shop_app_again/screens/auth_screen.dart';
import 'package:shop_app_again/screens/edit_product_screen.dart';
import 'package:shop_app_again/screens/splash_screen.dart';
import 'package:shop_app_again/screens/user_products_screen.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const routeName = 'Main_Method';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) =>
              Products(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) =>
              Orders(auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.orders),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomTransitionBuilder(),
                TargetPlatform.iOS:CustomTransitionBuilder()
              }
            )
          ),
          home: Consumer<Auth>(
              builder: (ctx, authData, _) =>
              authData.isAuth ? ProductsOverviewScreen() :
              FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (ctx, dataSnapshot)
                  =>   dataSnapshot.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(),
//                      : dataSnapshot.data == false
//                      ? AuthScreen()
//                      : ProductsOverviewScreen();

              )
          ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          }),
    );
  }
}
