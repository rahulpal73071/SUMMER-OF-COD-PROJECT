import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/add_product_page.dart';
import 'screens/welcome_page.dart';
import 'utils/root_app.dart';
import 'utils/local_storage.dart';
import 'pages/cart_page.dart';
import 'providers/cart_provider.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(useMaterial3: true),

        // ✅ Named Routes
        routes: {
          '/welcome': (context) => const WelcomePage(),
          '/home': (context) => const RootApp(),
          '/add-product': (context) => const AddProductPage(),
          '/cart': (context) => const CartPage(),
        },

        // ✅ Launch logic
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
