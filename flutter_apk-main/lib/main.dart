import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'config/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Stripe with publishable key
  Stripe.publishableKey = Keys.STRIPE_PUBLISHABLE_KEY;
  // If using Apple Pay, set merchant identifier
  Stripe.merchantIdentifier = Keys.APPLE_MERCHANT_ID;
  runApp(const TumorHealApp());
}

class TumorHealApp extends StatelessWidget {
  const TumorHealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'TumorHeal',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
