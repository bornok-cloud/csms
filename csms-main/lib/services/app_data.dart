import 'package:flutter/material.dart';
import '../models/models.dart';
import 'email_service.dart';

/// Central in-memory "backend" for the whole app.
/// A ChangeNotifier singleton so any screen can read/mutate shared mock data
/// and rebuild automatically. Structured so each method here is where a real
/// Firebase/REST call would eventually go.
class AppData extends ChangeNotifier {
  AppData._internal() {
    _seed();
  }
  static final AppData instance = AppData._internal();

  // ---------------- Session ----------------
  AppUser? currentUser;

  // ---------------- Collections ----------------
  final List<AppUser> users = [];
  final List<ArchivedRecord> archive = [];
  final List<Product> products = [];
  final List<InventoryItem> inventory = [];
  final List<OrderRecord> kioskOrders = [];
  final List<TransactionRecord> transactions = [];
  final List<Employee> employees = [];
  final List<AttendanceRecord> attendance = [];
  final List<FeedbackRecord> feedbacks = [];
  final List<Conversation> adminEmployeeChats = [];
  final List<PettyCashEntry> pettyCash = [];
  final List<ProcurementRecord> procurement = [];
  final List<PromotionRecord> promotions = [];
  final List<AppNotification> notifications = [];

  double pettyCashStart = 5000;

  int get unreadNotifications => notifications.where((n) => !n.read).length;

  void _seed() {
    // ---- Users (mock login accounts) ----
    users.addAll([
      AppUser(
        id: 'U-001',
        fullName: 'Rosa Villanueva',
        email: 'admin@cafe.com',
        phone: '0917-000-0001',
        role: UserRole.admin,
        dateRegistered: DateTime.now().subtract(const Duration(days: 400)),
        password: 'admin123',
      ),
      AppUser(
        id: 'U-002',
        fullName: 'Maria Santos',
        email: 'maria@cafe.com',
        phone: '0917-000-0002',
        role: UserRole.employee,
        dateRegistered: DateTime.now().subtract(const Duration(days: 300)),
        password: 'employee123',
        position: 'Barista',
        employeeId: 'E-001',
      ),
      AppUser(
        id: 'U-003',
        fullName: 'John Cruz',
        email: 'john@cafe.com',
        phone: '0917-000-0003',
        role: UserRole.employee,
        dateRegistered: DateTime.now().subtract(const Duration(days: 250)),
        password: 'employee123',
        position: 'Cashier',
        employeeId: 'E-002',
      ),
      AppUser(
        id: 'U-004',
        fullName: 'Anna Reyes',
        email: 'anna@cafe.com',
        phone: '0917-000-0004',
        role: UserRole.employee,
        dateRegistered: DateTime.now().subtract(const Duration(days: 200)),
        password: 'employee123',
        position: 'Kitchen Staff',
        employeeId: 'E-003',
      ),
      AppUser(
        id: 'U-005',
        fullName: 'Juan Dela Cruz',
        email: 'customer@cafe.com',
        phone: '0917-000-0005',
        role: UserRole.customer,
        dateRegistered: DateTime.now().subtract(const Duration(days: 20)),
        password: 'customer123',
      ),
    ]);

    // ---- Products ----
    final p = [
      Product(id: 'P-01', name: 'Iced Coffee', category: 'Coffee', price: 120, description: 'Classic iced coffee brewed fresh daily.', emoji: '🧊☕'),
      Product(id: 'P-02', name: 'Spanish Latte', category: 'Coffee', price: 140, description: 'Creamy, sweet, and bold espresso latte.', emoji: '☕'),
      Product(id: 'P-03', name: 'Americano', category: 'Coffee', price: 100, description: 'Espresso diluted with hot water.', emoji: '☕'),
      Product(id: 'P-04', name: 'Caramel Macchiato', category: 'Coffee', price: 150, description: 'Espresso with caramel and steamed milk.', emoji: '☕'),
      Product(id: 'P-05', name: 'Matcha Latte', category: 'Non-Coffee', price: 140, description: 'Premium matcha with fresh milk.', emoji: '🍵'),
      Product(id: 'P-06', name: 'Chocolate Frappe', category: 'Non-Coffee', price: 150, description: 'Rich chocolate blended frappe.', emoji: '🍫'),
      Product(id: 'P-07', name: 'Croissant', category: 'Pastries', price: 90, description: 'Buttery, flaky French pastry.', emoji: '🥐'),
      Product(id: 'P-08', name: 'Blueberry Muffin', category: 'Pastries', price: 85, description: 'Soft muffin loaded with blueberries.', emoji: '🧁'),
      Product(id: 'P-09', name: 'Club Sandwich', category: 'Snacks', price: 160, description: 'Triple-decker sandwich with fries.', emoji: '🥪'),
    ];
    products.addAll(p);

    // ---- Inventory (linked to products by name) ----
    inventory.addAll([
      InventoryItem(id: 'I-01', productName: 'Iced Coffee', quantity: 10, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-02', productName: 'Spanish Latte', quantity: 18, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-03', productName: 'Americano', quantity: 20, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-04', productName: 'Caramel Macchiato', quantity: 14, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-05', productName: 'Matcha Latte', quantity: 12, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-06', productName: 'Chocolate Frappe', quantity: 9, unit: 'servings', minimumStock: 5),
      InventoryItem(id: 'I-07', productName: 'Croissant', quantity: 15, unit: 'pcs', minimumStock: 6, expiration: DateTime.now().add(const Duration(days: 2))),
      InventoryItem(id: 'I-08', productName: 'Blueberry Muffin', quantity: 16, unit: 'pcs', minimumStock: 6, expiration: DateTime.now().add(const Duration(days: 5))),
      InventoryItem(id: 'I-09', productName: 'Club Sandwich', quantity: 10, unit: 'pcs', minimumStock: 4),
      InventoryItem(id: 'I-10', productName: 'Milk', quantity: 4, unit: 'liters', minimumStock: 5),
      InventoryItem(id: 'I-11', productName: 'Chocolate Syrup', quantity: 3, unit: 'bottles', minimumStock: 3, expiration: DateTime.now().add(const Duration(days: 5))),
    ]);

    // ---- Employees / Payroll ----
    employees.addAll([
      Employee(id: 'E-001', name: 'Maria Santos', position: 'Barista', hourlyRate: 75, hoursWorked: 88, overtimeHours: 4, bonus: 500, deductions: 200),
      Employee(id: 'E-002', name: 'John Cruz', position: 'Cashier', hourlyRate: 70, hoursWorked: 90, overtimeHours: 2, bonus: 0, deductions: 150),
      Employee(id: 'E-003', name: 'Anna Reyes', position: 'Kitchen Staff', hourlyRate: 72, hoursWorked: 85, overtimeHours: 5, bonus: 300, deductions: 100),
    ]);

    // ---- Attendance ----
    attendance.addAll([
      AttendanceRecord(employeeName: 'Maria Santos', date: DateTime.now().subtract(const Duration(days: 1)), timeIn: '8:02 AM', timeOut: '5:00 PM'),
      AttendanceRecord(employeeName: 'John Cruz', date: DateTime.now().subtract(const Duration(days: 1)), timeIn: '7:58 AM', timeOut: '5:05 PM'),
      AttendanceRecord(employeeName: 'Anna Reyes', date: DateTime.now().subtract(const Duration(days: 1)), timeIn: '8:15 AM', timeOut: '5:00 PM', status: 'Late'),
    ]);

    // ---- Feedback ----
    feedbacks.addAll([
      FeedbackRecord(id: 'F-01', customerName: 'Juan Dela Cruz', rating: 5, comment: 'Great coffee and fast service!', category: 'Service', date: DateTime.now().subtract(const Duration(days: 2))),
      FeedbackRecord(id: 'F-02', customerName: 'Liza Gomez', rating: 4, comment: 'Croissant was a bit cold.', category: 'Food Quality', date: DateTime.now().subtract(const Duration(days: 5)), status: 'Reviewed'),
    ]);

    // ---- Messaging ----
    adminEmployeeChats.addAll([
      Conversation(withName: 'Maria Santos', messages: [
        ChatMessage(sender: 'Maria Santos', text: 'Good morning! Milk delivery has not arrived yet.', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
        ChatMessage(sender: 'Admin', text: 'Noted, I will contact the supplier.', timestamp: DateTime.now().subtract(const Duration(hours: 2)), read: true),
      ]),
      Conversation(withName: 'John Cruz', messages: [
        ChatMessage(sender: 'John Cruz', text: 'Requesting schedule change for Saturday.', timestamp: DateTime.now().subtract(const Duration(days: 1))),
      ]),
      Conversation(withName: 'Anna Reyes', messages: [
        ChatMessage(sender: 'Admin', text: 'Please double check the pastry stock today.', timestamp: DateTime.now().subtract(const Duration(hours: 6)), read: true),
      ]),
    ]);

    // ---- Petty cash ----
    pettyCash.addAll([
      PettyCashEntry(description: 'Coffee Supplies', category: 'Supplies', amount: -500, date: DateTime.now().subtract(const Duration(days: 3))),
      PettyCashEntry(description: 'Cleaning Supplies', category: 'Maintenance', amount: -300, date: DateTime.now().subtract(const Duration(days: 2))),
    ]);

    // ---- Procurement ----
    procurement.addAll([
      ProcurementRecord(id: 'PR-01', productName: 'Milk', supplier: 'Green Farms Dairy', quantity: 20, cost: 1800, date: DateTime.now().subtract(const Duration(days: 1)), status: 'Requested'),
    ]);

    // ---- Notifications ----
    notifications.addAll([
      AppNotification(title: 'LOW STOCK', body: 'Milk is running low.', type: 'Inventory', time: DateTime.now().subtract(const Duration(hours: 1))),
      AppNotification(title: 'NEAR EXPIRATION', body: 'Chocolate Syrup expires in 5 days.', type: 'Expiration', time: DateTime.now().subtract(const Duration(hours: 2))),
      AppNotification(title: 'NEW FEEDBACK', body: 'A customer submitted a 5-star review.', type: 'Feedback', time: DateTime.now().subtract(const Duration(days: 2))),
    ]);
  }

  // ===================== AUTH =====================
  AppUser? login(String email, String password) {
    final match = users.where((u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password && u.status == 'Active');
    if (match.isEmpty) return null;
    currentUser = match.first;
    notifyListeners();
    return currentUser;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  /// Creates the pending user, generates a real OTP, and emails it via
  /// Gmail SMTP. Throws [EmailSendException] if the email fails to send
  /// (the user is still created with 'Pending Verification' status, and
  /// the caller can offer to resend).
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = AppUser(
      id: 'U-${(users.length + 1).toString().padLeft(3, '0')}',
      fullName: fullName,
      email: email,
      phone: phone,
      role: UserRole.customer,
      dateRegistered: DateTime.now(),
      password: password,
      status: 'Pending Verification',
    );
    users.add(user);
    notifyListeners();

    lastOtpError = null;
    try {
      await _generateAndSendOtp(user);
    } on EmailSendException catch (e) {
      // Keep the user record so they land on the OTP screen and can hit
      // "Resend OTP" once the email config / connection is fixed, instead
      // of losing the whole registration.
      lastOtpError = e.message;
    }
    return user;
  }

  /// Set by [register]/[resendOtp] when the most recent OTP email attempt
  /// failed, so the UI can surface it. `null` means the last attempt (or
  /// none yet) succeeded.
  String? lastOtpError;

  /// Generates a fresh 6-digit OTP for [user], stores it with a 5-minute
  /// expiry, and sends it to the user's email address.
  Future<void> _generateAndSendOtp(AppUser user) async {
    final otp = EmailService.instance.generateOtp();
    user.otpCode = otp;
    user.otpExpiry = DateTime.now().add(const Duration(minutes: 5));
    notifyListeners();

    await EmailService.instance.sendOtpEmail(
      toEmail: user.email,
      toName: user.fullName,
      otp: otp,
    );
  }

  /// Regenerates and resends the OTP for the user with [userId] (used by
  /// the "Resend OTP" button).
  Future<void> resendOtp(String userId) async {
    final u = users.firstWhere((u) => u.id == userId);
    lastOtpError = null;
    try {
      await _generateAndSendOtp(u);
    } on EmailSendException catch (e) {
      lastOtpError = e.message;
      rethrow;
    }
  }

  /// Checks [code] against the stored OTP for [userId]. Returns:
  ///  - `null` on success
  ///  - an error message string on failure (wrong code / expired code)
  String? verifyOtp(String userId, String code) {
    final u = users.firstWhere((u) => u.id == userId);
    if (u.otpCode == null || u.otpExpiry == null) {
      return 'No active code. Please request a new one.';
    }
    if (DateTime.now().isAfter(u.otpExpiry!)) {
      return 'This code has expired. Please resend a new one.';
    }
    if (code != u.otpCode) {
      return 'Incorrect OTP. Please try again.';
    }
    u.status = 'Active';
    u.otpCode = null;
    u.otpExpiry = null;
    notifyListeners();
    return null;
  }

  // ===================== NOTIFICATIONS =====================
  void pushNotification(String title, String body, String type) {
    notifications.insert(0, AppNotification(title: title, body: body, type: type, time: DateTime.now()));
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  // ===================== INVENTORY / POS =====================
  InventoryItem? _findInventory(String productName) {
    try {
      return inventory.firstWhere((i) => i.productName == productName);
    } catch (_) {
      return null;
    }
  }

  /// Deducts stock for each cart item and raises low-stock alerts as needed.
  void deductInventoryForSale(List<CartItem> items) {
    for (final item in items) {
      final inv = _findInventory(item.product.name);
      if (inv == null) continue;
      inv.quantity = (inv.quantity - item.quantity).clamp(0, 1 << 30);
      if (inv.quantity <= inv.minimumStock) {
        pushNotification('LOW STOCK', '${inv.productName} is running low (${inv.quantity} ${inv.unit} left).', 'Inventory');
      }
    }
    notifyListeners();
  }

  TransactionRecord checkout({required List<CartItem> items, required double discount, required String cashier}) {
    final subtotal = items.fold(0.0, (s, i) => s + i.subtotal);
    final total = (subtotal - discount).clamp(0, double.infinity).toDouble();
    final tx = TransactionRecord(
      id: 'TX-${(transactions.length + 1).toString().padLeft(4, '0')}',
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      timestamp: DateTime.now(),
      cashier: cashier,
    );
    transactions.add(tx);
    deductInventoryForSale(items);
    notifyListeners();
    return tx;
  }

  // ===================== KIOSK ORDERS =====================
  OrderRecord placeKioskOrder(List<CartItem> items, {String? customerName}) {
    final order = OrderRecord(
      id: '${1000 + kioskOrders.length + 24}',
      items: items,
      source: 'Kiosk',
      createdAt: DateTime.now(),
      customerName: customerName ?? currentUser?.fullName,
    );
    kioskOrders.insert(0, order);
    pushNotification('NEW ORDER', 'A new kiosk order (#${order.id}) has been received.', 'POS');
    notifyListeners();
    return order;
  }

  void acceptKioskOrder(String orderId, {required String cashier}) {
    final order = kioskOrders.firstWhere((o) => o.id == orderId);
    checkout(items: order.items, discount: order.discount, cashier: cashier);
    kioskOrders.remove(order);
    notifyListeners();
  }

  void declineKioskOrder(String orderId) {
    kioskOrders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }

  // ===================== PAYROLL =====================
  void markPayrollPaid(String employeeId) {
    final e = employees.firstWhere((e) => e.id == employeeId);
    e.status = 'Paid';
    pushNotification('PAYROLL', 'Payroll for ${e.name} is ready for viewing.', 'Payroll');
    notifyListeners();
  }

  double get totalPayrollExpense => employees.fold(0, (s, e) => s + e.netSalary);

  // ===================== ATTENDANCE =====================
  AttendanceRecord recordAttendance(String employeeName, {String method = 'RFID'}) {
    final now = TimeOfDay.now();
    final label = '${now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';
    final status = now.hour > 8 || (now.hour == 8 && now.minute > 10) ? 'Late' : 'Present';
    final record = AttendanceRecord(employeeName: employeeName, date: DateTime.now(), timeIn: label, status: status, method: method);
    attendance.insert(0, record);
    notifyListeners();
    return record;
  }

  // ===================== FEEDBACK =====================
  FeedbackRecord submitFeedback({required String customerName, required int rating, required String comment, required String category}) {
    final fb = FeedbackRecord(
      id: 'F-${(feedbacks.length + 1).toString().padLeft(2, '0')}',
      customerName: customerName,
      rating: rating,
      comment: comment,
      category: category,
      date: DateTime.now(),
    );
    feedbacks.insert(0, fb);
    pushNotification('NEW FEEDBACK', 'A customer submitted a $rating-star review.', 'Feedback');
    notifyListeners();
    return fb;
  }

  void markFeedbackReviewed(String id, {String? reply}) {
    final fb = feedbacks.firstWhere((f) => f.id == id);
    fb.status = 'Reviewed';
    if (reply != null) fb.reply = reply;
    notifyListeners();
  }

  // ===================== PETTY CASH =====================
  double get pettyCashBalance => pettyCashStart + pettyCash.fold(0.0, (s, e) => s + e.amount);
  double get pettyCashExpenses => pettyCash.where((e) => e.amount < 0).fold(0.0, (s, e) => s + e.amount.abs());
  double get pettyCashAdded => pettyCash.where((e) => e.amount > 0).fold(0.0, (s, e) => s + e.amount);

  void addPettyCash(String description, String category, double amount) {
    pettyCash.insert(0, PettyCashEntry(description: description, category: category, amount: amount, date: DateTime.now()));
    notifyListeners();
  }

  // ===================== PROCUREMENT =====================
  void addProcurement(String productName, String supplier, int quantity, double cost) {
    procurement.insert(0, ProcurementRecord(
      id: 'PR-${(procurement.length + 1).toString().padLeft(2, '0')}',
      productName: productName,
      supplier: supplier,
      quantity: quantity,
      cost: cost,
      date: DateTime.now(),
      status: 'Restocked',
    ));
    final inv = _findInventory(productName);
    if (inv != null) inv.quantity += quantity;
    notifyListeners();
  }

  // ===================== PROMOTIONS =====================
  void addPromotion(String productName, String promoType) {
    promotions.insert(0, PromotionRecord(productName: productName, promoType: promoType, createdAt: DateTime.now()));
    notifyListeners();
  }

  // ===================== USER MANAGEMENT / ARCHIVE =====================
  void addUser(AppUser user) {
    users.add(user);
    notifyListeners();
  }

  void archiveUser(String userId, {String archivedBy = 'Admin'}) {
    final user = users.firstWhere((u) => u.id == userId);
    archive.add(ArchivedRecord(
      id: user.id,
      category: 'Users',
      name: user.fullName,
      email: user.email,
      role: user.roleLabel,
      dateArchived: DateTime.now(),
      archivedBy: archivedBy,
      originalUser: user,
    ));
    users.remove(user);
    notifyListeners();
  }

  void restoreUser(String recordId) {
    final record = archive.firstWhere((r) => r.id == recordId);
    if (record.originalUser != null) {
      users.add(record.originalUser!);
    }
    archive.remove(record);
    notifyListeners();
  }

  void permanentlyDelete(String recordId) {
    archive.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }
}
