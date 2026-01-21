import 'package:flutter/material.dart';
import '../models/data_models.dart';

class MockDataService extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Mock Users
  final List<User> _users = [
    User(id: 'u1', name: 'Admin User', role: UserRole.admin),
    User(id: 'u2', name: 'Warehouse Staff', role: UserRole.warehouse),
    User(id: 'u3', name: 'Driver Dave', role: UserRole.driver),
    User(id: 'u4', name: 'Finance Fiona', role: UserRole.finance),
  ];

  // Mock Data
  final List<Customer> _customers = [
    Customer(id: 'c1', businessName: 'Acme Corp', address: '123 Ind. Park', contactNumber: '555-0101'),
    Customer(id: 'c2', businessName: 'Global Logistics', address: '456 Harbor View', contactNumber: '555-0102'),
  ];

  final List<Project> _projects = [
    Project(id: 'p1', name: 'Acme HQ Reno', customerId: 'c1'),
    Project(id: 'p2', name: 'Acme Annex', customerId: 'c1'),
    Project(id: 'p3', name: 'Global Expansion', customerId: 'c2'),
  ];

  List<Delivery> _deliveries = [];

  MockDataService() {
    _generateMockDeliveries();
  }

  void _generateMockDeliveries() {
    _deliveries = [
      Delivery(
        id: 'd1',
        date: DateTime.now(),
        driverId: 'u3',
        status: DeliveryStatus.outForDelivery,
        customerId: 'c1',
        projectDeliveries: [
          ProjectDelivery(id: 'pd1', projectId: 'p1', deliveryId: 'd1'),
          ProjectDelivery(id: 'pd2', projectId: 'p2', deliveryId: 'd1'),
        ],
      ),
      Delivery(
        id: 'd2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        driverId: 'u3',
        status: DeliveryStatus.completed,
        customerId: 'c2',
        projectDeliveries: [
          ProjectDelivery(
            id: 'pd3',
            projectId: 'p3',
            deliveryId: 'd2',
            status: ProjectDeliveryStatus.delivered,
            completedAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
      ),
    ];
  }

  List<Delivery> getDeliveriesForUser() {
    if (_currentUser == null) return [];
    if (_currentUser!.role == UserRole.admin || _currentUser!.role == UserRole.finance || _currentUser!.role == UserRole.warehouse) {
      return _deliveries;
    }
    // Driver sees only their deliveries
    return _deliveries.where((d) => d.driverId == _currentUser!.id).toList();
  }

  Delivery? getDelivery(String id) {
    try {
      return _deliveries.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Customer? getCustomer(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Project? getProject(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void login(String userId) {
    _currentUser = _users.firstWhere((u) => u.id == userId);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProjectDeliveryStatus(String deliveryId, String projectDeliveryId, ProjectDeliveryStatus status) {
    // In a real app, this would update the backend
    // Here we just update the local object (deep copy logic omitted for brevity in mock)
    final deliveryIndex = _deliveries.indexWhere((d) => d.id == deliveryId);
    if (deliveryIndex != -1) {
      final pdIndex = _deliveries[deliveryIndex].projectDeliveries.indexWhere((pd) => pd.id == projectDeliveryId);
      if (pdIndex != -1) {
        _deliveries[deliveryIndex].projectDeliveries[pdIndex].status = status;
        if (status == ProjectDeliveryStatus.delivered) {
             _deliveries[deliveryIndex].projectDeliveries[pdIndex].completedAt = DateTime.now();
        }
        notifyListeners();
      }
    }
  }
}
