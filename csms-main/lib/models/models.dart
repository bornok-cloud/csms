/// All core data models for the Café Management System (mock/local data layer).
/// Kept in a single file for simplicity; can be split when wiring to a real backend.
library;

enum UserRole { admin, employee, customer }

class AppUser {
  String id;
  String fullName;
  String email;
  String phone;
  UserRole role;
  String status; // Active, Disabled
  DateTime dateRegistered;
  String password; // mock only - never do this in production
  String? position; // for employees
  String? employeeId;
  String? otpCode; // mock only - the currently active OTP for this user
  DateTime? otpExpiry;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.status = 'Active',
    required this.dateRegistered,
    required this.password,
    this.position,
    this.employeeId,
    this.otpCode,
    this.otpExpiry,
  });

  String get roleLabel {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.employee:
        return 'Employee';
      case UserRole.customer:
        return 'Customer';
    }
  }
}

class ArchivedRecord {
  final String id;
  final String category; // Users, Employees, Products, Other Records
  final String name;
  final String email;
  final String role;
  final DateTime dateArchived;
  final String archivedBy;
  final AppUser? originalUser;

  ArchivedRecord({
    required this.id,
    required this.category,
    required this.name,
    required this.email,
    required this.role,
    required this.dateArchived,
    required this.archivedBy,
    this.originalUser,
  });
}

class Product {
  final String id;
  String name;
  String category;
  double price;
  String description;
  String emoji; // stand-in for a product image

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.emoji,
  });
}

class InventoryItem {
  final String id;
  String productName;
  int quantity;
  String unit;
  int minimumStock;
  DateTime? expiration;

  InventoryItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.minimumStock,
    this.expiration,
  });

  String get status {
    if (quantity <= 0) return 'Out of Stock';
    if (expiration != null) {
      final daysLeft = expiration!.difference(DateTime.now()).inDays;
      if (daysLeft < 0) return 'Expired';
      if (daysLeft <= 5) return 'Near Expiration';
    }
    if (quantity <= minimumStock) return 'Low Stock';
    return 'In Stock';
  }
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
  double get subtotal => product.price * quantity;
}

class OrderRecord {
  final String id;
  final List<CartItem> items;
  final String source; // Kiosk, POS
  final String status; // Pending, Accepted, Completed
  final DateTime createdAt;
  final String? customerName;
  double discount;

  OrderRecord({
    required this.id,
    required this.items,
    required this.source,
    this.status = 'Pending',
    required this.createdAt,
    this.customerName,
    this.discount = 0,
  });

  double get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);
  double get total => (subtotal - discount).clamp(0, double.infinity);
}

class TransactionRecord {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final DateTime timestamp;
  final String cashier;

  TransactionRecord({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.timestamp,
    required this.cashier,
  });
}

class Employee {
  final String id;
  String name;
  String position;
  double hourlyRate;
  double hoursWorked;
  double overtimeHours;
  double bonus;
  double deductions;
  String status; // Paid, Pending

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.hourlyRate,
    this.hoursWorked = 0,
    this.overtimeHours = 0,
    this.bonus = 0,
    this.deductions = 0,
    this.status = 'Pending',
  });

  double get basicSalary => hourlyRate * hoursWorked;
  double get overtimePay => hourlyRate * 1.25 * overtimeHours;
  double get netSalary => basicSalary + overtimePay + bonus - deductions;
}

class AttendanceRecord {
  final String employeeName;
  final DateTime date;
  final String timeIn;
  String? timeOut;
  final String status;
  final String method; // RFID, QR

  AttendanceRecord({
    required this.employeeName,
    required this.date,
    required this.timeIn,
    this.timeOut,
    this.status = 'Present',
    this.method = 'RFID',
  });
}

class FeedbackRecord {
  final String id;
  final String customerName;
  final int rating;
  final String comment;
  final String category;
  final DateTime date;
  String status; // New, Reviewed
  String? reply;

  FeedbackRecord({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.category,
    required this.date,
    this.status = 'New',
    this.reply,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  bool read;
  ChatMessage(
      {required this.sender,
      required this.text,
      required this.timestamp,
      this.read = false});
}

class Conversation {
  final String withName;
  final List<ChatMessage> messages;
  Conversation({required this.withName, required this.messages});
}

class PettyCashEntry {
  final String description;
  final String category;
  final double amount; // positive = cash added, negative = expense
  final DateTime date;
  PettyCashEntry(
      {required this.description,
      required this.category,
      required this.amount,
      required this.date});
}

class ProcurementRecord {
  final String id;
  final String productName;
  final String supplier;
  final int quantity;
  final double cost;
  final DateTime date;
  final String status; // Requested, Restocked
  ProcurementRecord({
    required this.id,
    required this.productName,
    required this.supplier,
    required this.quantity,
    required this.cost,
    required this.date,
    this.status = 'Requested',
  });
}

class PromotionRecord {
  final String productName;
  final String promoType; // Buy 1 Take 1, 10% Discount, etc.
  final DateTime createdAt;
  PromotionRecord(
      {required this.productName,
      required this.promoType,
      required this.createdAt});
}

class AppNotification {
  final String title;
  final String body;
  final String type; // Inventory, Expiration, POS, Feedback, Payroll
  final DateTime time;
  bool read;
  AppNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.read = false,
  });
}
