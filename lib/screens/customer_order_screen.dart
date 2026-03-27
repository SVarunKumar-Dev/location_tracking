import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/order_provider.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/primary_button.dart';
import 'customer_tracking_screen.dart';

class CustomerOrderScreen extends StatelessWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Order Food")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownField<String>(
              hint: "Select Food",
              value: provider.food,
              items: AppConstants.foodMenu,
              onChanged: provider.setFood,
            ),
            const SizedBox(height: 16),
            DropdownField<int>(
              hint: "Quantity",
              value: provider.qty,
              items: AppConstants.quantities,
              onChanged: (v) => provider.setQty(v!),
            ),
            const SizedBox(height: 20),
            Text("Amount: ₹${provider.amount}"),
            Text("Total: ₹${provider.total}"),
            const SizedBox(height: 20),

            provider.isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
                    text: "Submit Order",
                    onPressed: provider.food == null
                        ? null
                        : () async {
                            final id = await provider.submitOrder();
                            if (id != null && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CustomerTrackingScreen(orderId: id),
                                ),
                              );
                            }
                          },
                  ),
          ],
        ),
      ),
    );
  }
}
