import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/location_service.dart';
import '../utils/firestore_utils.dart';

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen>
    with SingleTickerProviderStateMixin {
  String? currentOrderId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void acceptOrder(String id) {
    setState(() {
      currentOrderId = id;
    });

    FirestoreUtils.updateOrder(id, {
      "status": "accepted",
      "driverId": "driver_1",
    });

    final locationService = Provider.of<LocationService>(
      context,
      listen: false,
    );
    locationService.startTracking(orderId: id);
  }

  Future<void> completeOrder() async {
    if (currentOrderId == null) return;

    await FirestoreUtils.updateOrder(currentOrderId!, {"status": "completed"});

    if (!mounted) return;

    final locationService = Provider.of<LocationService>(
      context,
      listen: false,
    );
    locationService.stopTracking();

    setState(() {
      currentOrderId = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order Completed")));
  }

  Widget buildOrderList(String screenView, Stream stream) {
    final isOnDelivery = currentOrderId != null;

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
          return const Center(child: Text("No Orders"));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (_, i) {
            var data = orders[i];

            return ListTile(
              title: Text(data['foodName']),
              subtitle: Text("Qty: ${data['quantity']}"),
              trailing: screenView == "Pending"
                  ? ElevatedButton(
                      onPressed: isOnDelivery
                          ? null
                          : () => acceptOrder(data.id),
                      child: const Text("Accept"),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnDelivery = currentOrderId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Orders"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList("Pending", FirestoreUtils.getPendingOrders()),

          buildOrderList("Completed", FirestoreUtils.getCompleteOrders()),
        ],
      ),
      floatingActionButton: isOnDelivery
          ? FloatingActionButton.extended(
              onPressed: completeOrder,
              label: const Text("Complete Order"),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
