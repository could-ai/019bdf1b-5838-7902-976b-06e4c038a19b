import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/data_models.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.warehouse, size: 80, color: Color(0xFF1A73E8)),
              const SizedBox(height: 24),
              const Text(
                'Warehouse Deliveries',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              const Text('Select Role to Simulate Login:', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              _LoginButton(userId: 'u1', label: 'Admin (Full Access)', icon: Icons.admin_panel_settings),
              const SizedBox(height: 12),
              _LoginButton(userId: 'u2', label: 'Warehouse Staff', icon: Icons.inventory),
              const SizedBox(height: 12),
              _LoginButton(userId: 'u3', label: 'Driver (Mobile View)', icon: Icons.local_shipping),
              const SizedBox(height: 12),
              _LoginButton(userId: 'u4', label: 'Finance (View Only)', icon: Icons.attach_money),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String userId;
  final String label;
  final IconData icon;

  const _LoginButton({required this.userId, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        Provider.of<MockDataService>(context, listen: false).login(userId);
        Navigator.pushReplacementNamed(context, '/dashboard');
      },
    );
  }
}
