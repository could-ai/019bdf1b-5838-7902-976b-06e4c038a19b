enum UserRole { admin, warehouse, driver, finance }

class User {
  final String id;
  final String name;
  final UserRole role;

  User({required this.id, required this.name, required this.role});
}

class Customer {
  final String id;
  final String businessName;
  final String address;
  final String contactNumber;

  Customer({
    required this.id,
    required this.businessName,
    required this.address,
    required this.contactNumber,
  });
}

class Project {
  final String id;
  final String name;
  final String customerId;

  Project({required this.id, required this.name, required this.customerId});
}

enum DeliveryStatus { draft, scheduled, outForDelivery, completed, cancelled }

class Delivery {
  final String id;
  final DateTime date;
  final String driverId;
  final DeliveryStatus status;
  final String customerId;
  final List<ProjectDelivery> projectDeliveries;

  Delivery({
    required this.id,
    required this.date,
    required this.driverId,
    required this.status,
    required this.customerId,
    required this.projectDeliveries,
  });
}

enum ProjectDeliveryStatus { pending, delivered, rejected }

class ProjectDelivery {
  final String id;
  final String projectId;
  final String deliveryId;
  ProjectDeliveryStatus status;
  String? signatureUrl;
  String? podUrl;
  DateTime? completedAt;

  ProjectDelivery({
    required this.id,
    required this.projectId,
    required this.deliveryId,
    this.status = ProjectDeliveryStatus.pending,
    this.signatureUrl,
    this.podUrl,
    this.completedAt,
  });
}

class PickingList {
  final String id;
  final String deliveryId;
  final List<PickingItem> items;
  final bool isCompleted;

  PickingList({
    required this.id,
    required this.deliveryId,
    required this.items,
    this.isCompleted = false,
  });
}

class PickingItem {
  final String id;
  final String name;
  final int quantity;
  final bool isPicked;

  PickingItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.isPicked = false,
  });
}
