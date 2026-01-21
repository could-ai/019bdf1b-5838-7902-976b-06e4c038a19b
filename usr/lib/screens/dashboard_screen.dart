import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/data_models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MockDataService>(context).currentUser;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name} (${user.role.name.toUpperCase()})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<MockDataService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCards(context, user),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActionGrid(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, User user) {
    // In a real app, these would be calculated from the service
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Pending',
            value: '5',
            color: Colors.orange,
            icon: Icons.pending_actions,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Completed',
            value: '12',
            color: Colors.green,
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context, User user) {
    List<Widget> actions = [];

    // Common Action
    actions.add(_ActionCard(
      title: 'My Deliveries',
      icon: Icons.local_shipping,
      color: Colors.blue,
      onTap: () => Navigator.pushNamed(context, '/deliveries'),
    ));

    if (user.role == UserRole.warehouse || user.role == UserRole.admin) {
      actions.add(_ActionCard(
        title: 'Picking Lists',
        icon: Icons.list_alt,
        color: Colors.purple,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Picking Lists module coming soon')));
        },
      ));
      actions.add(_ActionCard(
        title: 'New Delivery',
        icon: Icons.add_box,
        color: Colors.teal,
        onTap: () {},
      ));
    }

    if (user.role == UserRole.finance || user.role == UserRole.admin) {
      actions.add(_ActionCard(
        title: 'POD Audit',
        icon: Icons.receipt_long,
        color: Colors.indigo,
        onTap: () {},
      ));
    }

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: actions,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
