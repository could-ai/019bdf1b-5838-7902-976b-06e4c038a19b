import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/login_screen.dart';
import 'package:couldai_user_app/screens/dashboard_screen.dart';
import 'package:couldai_user_app/screens/delivery_list_screen.dart';
import 'package:couldai_user_app/screens/delivery_detail_screen.dart';
import 'package:couldai_user_app/services/mock_data_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MockDataService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8), // Enterprise Blue
          secondary: const Color(0xFFE37400), // Safety Orange for Warehouse
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/deliveries': (context) => const DeliveryListScreen(),
        // '/delivery_detail': (context) => const DeliveryDetailScreen(), // Passed via arguments usually
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/delivery_detail') {
          final args = settings.arguments as String; // Delivery ID
          return MaterialPageRoute(
            builder: (context) => DeliveryDetailScreen(deliveryId: args),
          );
        }
        return null;
      },
    );
  }
}
