import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  // Color scheme constants
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color accentGreen = Color(0xFF7ED321);
  static const Color warningOrange = Color(0xFFF5A623);
  static const Color errorRed = Color(0xFFD0021B);
  static const Color neutralGrey = Color(0xFF9B9B9B);

  Color getStatusColor() {
    switch (status) {
      case 'New':
        return primaryBlue;
      case 'Contacted':
        return warningOrange;
      case 'Converted':
        return accentGreen;
      case 'Lost':
        return errorRed;
      default:
        return neutralGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
