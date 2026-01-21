import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/data_models.dart';
import 'package:intl/intl.dart';

class DeliveryListScreen extends StatelessWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<MockDataService>(context);
    final deliveries = service.getDeliveriesForUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          final customer = service.getCustomer(delivery.customerId);
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(delivery.status).withOpacity(0.1),
                child: Icon(_getStatusIcon(delivery.status), color: _getStatusColor(delivery.status)),
              ),
              title: Text(customer?.businessName ?? 'Unknown Customer', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('ID: ${delivery.id} • ${DateFormat('MMM dd, yyyy').format(delivery.date)}'),
                  const SizedBox(height: 4),
                  Text('${delivery.projectDeliveries.length} Projects Linked'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/delivery_detail', arguments: delivery.id);
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.completed: return Colors.green;
      case DeliveryStatus.outForDelivery: return Colors.blue;
      case DeliveryStatus.draft: return Colors.grey;
      default: return Colors.orange;
    }
  }

  IconData _getStatusIcon(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.completed: return Icons.check;
      case DeliveryStatus.outForDelivery: return Icons.local_shipping;
      case DeliveryStatus.draft: return Icons.edit_note;
      default: return Icons.schedule;
    }
  }
}
