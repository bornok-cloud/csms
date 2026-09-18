import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _scanning = false;
  String _method = 'RFID';
  AttendanceRecord? _lastRecord;

  void _scan() {
    setState(() {
      _scanning = true;
      _lastRecord = null;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final user = AppData.instance.currentUser!;
      final record =
          AppData.instance.recordAttendance(user.fullName, method: _method);
      setState(() {
        _scanning = false;
        _lastRecord = record;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final myHistory = data.attendance
            .where((a) => a.employeeName == data.currentUser!.fullName)
            .toList();

        return SectionPage(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('SCAN RFID / QR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.darkBrown)),
                  const SizedBox(height: 16),
                  ToggleButtons(
                    isSelected: [_method == 'RFID', _method == 'QR'],
                    onPressed: (i) =>
                        setState(() => _method = i == 0 ? 'RFID' : 'QR'),
                    borderRadius: BorderRadius.circular(10),
                    children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('RFID')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('QR Code'))
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _scanning ? null : _scan,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.brown.withValues(alpha: 0.4),
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      alignment: Alignment.center,
                      child: _scanning
                          ? const CircularProgressIndicator(
                              color: AppColors.brown)
                          : Icon(
                              _method == 'RFID'
                                  ? Icons.credit_card
                                  : Icons.qr_code_scanner,
                              size: 64,
                              color: AppColors.brown),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                      _scanning
                          ? 'Waiting for scan...'
                          : 'Tap the scan area to simulate a scan',
                      style: const TextStyle(color: AppColors.textMuted)),
                  if (_lastRecord != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          const Text('✅ Attendance recorded successfully.',
                              style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Employee: ${_lastRecord!.employeeName}'),
                          Text('Time In: ${_lastRecord!.timeIn}'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Status: '),
                                StatusBadge(status: _lastRecord!.status)
                              ]),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Attendance History',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ResponsiveTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Time In')),
              DataColumn(label: Text('Time Out')),
              DataColumn(label: Text('Method')),
              DataColumn(label: Text('Status')),
            ],
            rows: myHistory
                .map((a) => DataRow(cells: [
                      DataCell(
                          Text('${a.date.month}/${a.date.day}/${a.date.year}')),
                      DataCell(Text(a.timeIn)),
                      DataCell(Text(a.timeOut ?? '—')),
                      DataCell(Text(a.method)),
                      DataCell(StatusBadge(status: a.status)),
                    ]))
                .toList(),
          ),
        ]);
      },
    );
  }
}
