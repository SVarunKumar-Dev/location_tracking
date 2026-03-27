import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import '../utils/firestore_utils.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Tracking")),
      body: StreamBuilder(
        stream: FirestoreUtils.getOrderLocation(widget.orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final location = snapshot.data!.docs;

          if (location.isEmpty) {
            return const Center(child: Text("No location updates yet"));
          }

          return ListView.builder(
            itemCount: location.length,
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            itemBuilder: (_, i) {
              return ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  "${location[i]["latitude"].toStringAsFixed(6)}, ${location[i]["longitude"].toStringAsFixed(6)}",
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 14.0),
                    Text(location[i]["address"]),
                    const SizedBox(height: 14.0),
                    Text(
                      DateFormat(
                        AppConstants.outputDateTimeFormat,
                      ).format(DateTime.parse(location[i]["timestamp"])),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
