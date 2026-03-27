import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import 'customer_order_screen.dart';
import 'driver_orders_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: "Customer",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerOrderScreen(),
                  ),
                  (value) => false,
                );
              },
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Driver",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverOrdersScreen()),
                  (value) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
