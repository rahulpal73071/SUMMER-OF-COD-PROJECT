import 'package:amazon_soc/screens/checkout_page.dart';
import 'package:amazon_soc/screens/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/add_product_page.dart';
import 'pages/cart_page.dart';
import 'pages/product/your_products_page.dart';
import 'providers/cart_provider.dart';
import 'utils/user_provider.dart'; // ✅ Import
import 'screens/admin_register_page.dart';
import 'screens/welcome_page.dart';
import 'utils/local_storage.dart';
import 'utils/root_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getStartPage() async {
    final isLoggedIn = await LocalStorage.isLoggedIn();
    return isLoggedIn ? const RootApp() : const WelcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // ✅ ADD THIS
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(useMaterial3: true),
        routes: {
          

          '/welcome': (context) => const WelcomePage(),
          '/home': (context) => const RootApp(),
          '/add-product': (context) => const AddProductPage(),
          '/cart': (context) => const CartPage(),
          '/your-products': (_) => const YourProductsPage(),
          '/register-admin': (_) => const AdminRegisterPage(),
          '/checkout':(_)=> const CheckoutPage(),
        },
        home: FutureBuilder<Widget>(
          future: getStartPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return snapshot.data!;
          },
        ),
      ),
    );
  }
}
