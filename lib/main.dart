import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan import ini sesuai dengan nama folder Anda
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login_screen.dart';
import 'screens/product_screen.dart';

void main() {
  runApp(
    // SOLUSI: MultiProvider diletakkan DI SINI (membungkus MyApp)
    // agar seluruh aplikasi bisa mengakses data Auth dan Produk.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cashier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Gunakan style standar dulu biar aman
      ),
      // LOGIKA UTAMA: Cek status login
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Jika token ada (sudah login) -> Buka Layar Produk
          if (auth.isAuthenticated) {
            return ProductScreen();
          }
          // Jika belum -> Buka Layar Login
          else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}