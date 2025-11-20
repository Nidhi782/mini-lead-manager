import 'package:flutter/material.dart';
import '../models/lead_model.dart';
import '../themes/app_themes.dart';
import 'status_badge.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadCard({
    super.key,
    required this.lead,
    required this.onTap,
  });

  bool _isEmail(String contact) {
    if (contact.isEmpty) return false;
    // More robust email detection: must contain @ and . after @
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(contact.trim());
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = _isEmail(lead.contact);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusLG,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar/Initial circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: AppRadius.radiusMD,
                    ),
                    child: Center(
                      child: Text(
                        lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        StatusBadge(status: lead.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Contact information
              Row(
                children: [
                  Container(
                    padding: AppSpacing.paddingSM,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: AppRadius.radiusSM,
                    ),
                    child: Icon(
                      isEmail ? Icons.email_outlined : Icons.phone_outlined,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      lead.contact,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutralGrey,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Created date
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.neutralGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(lead.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
