import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/data_models.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final String deliveryId;

  const DeliveryDetailScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<MockDataService>(context);
    final delivery = service.getDelivery(deliveryId);

    if (delivery == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Delivery not found')));
    }

    final customer = service.getCustomer(delivery.customerId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery ${delivery.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerSection(customer),
            const SizedBox(height: 24),
            const Text('Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...delivery.projectDeliveries.map((pd) => _buildProjectCard(context, pd, service)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection(Customer? customer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: Colors.grey),
                const SizedBox(width: 8),
                Text(customer?.businessName ?? 'Unknown', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            Text(customer?.address ?? ''),
            const SizedBox(height: 4),
            Text('Contact: ${customer?.contactNumber ?? ''}'),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectDelivery pd, MockDataService service) {
    final project = service.getProject(pd.projectId);
    final isCompleted = pd.status == ProjectDeliveryStatus.delivered;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCompleted ? Colors.green : Colors.grey.shade300, width: isCompleted ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(project?.name ?? 'Unknown Project', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Chip(
                  label: Text(pd.status.name.toUpperCase()),
                  backgroundColor: isCompleted ? Colors.green[100] : Colors.orange[100],
                  labelStyle: TextStyle(color: isCompleted ? Colors.green[800] : Colors.orange[800], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!isCompleted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.draw),
                  label: const Text('Capture Signature & POD'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to signature screen (mock action)
                    _showSignatureDialog(context, service, pd);
                  },
                ),
              )
            else
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text('Signed & POD Uploaded'),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('View POD')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showSignatureDialog(BuildContext context, MockDataService service, ProjectDelivery pd) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Delivery'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Simulate signature capture and POD upload?'),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Receiver Name', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              service.updateProjectDeliveryStatus(pd.deliveryId, pd.id, ProjectDeliveryStatus.delivered);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery Completed & POD Generated')));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
