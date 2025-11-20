import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/lead_provider.dart';
import '../models/lead_model.dart';
import '../widgets/status_badge.dart';
import '../themes/app_themes.dart';
import 'edit_lead_screen.dart';

class LeadDetailsScreen extends ConsumerStatefulWidget {
  final int leadId;

  const LeadDetailsScreen({
    super.key,
    required this.leadId,
  });

  @override
  ConsumerState<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends ConsumerState<LeadDetailsScreen> {
  Lead? _lead;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLead();
    });
  }

  Future<void> _loadLead() async {
    final lead =
        await ref.read(leadDbServiceProvider).getLeadById(widget.leadId);
    if (mounted) {
      setState(() {
        _lead = lead;
      });
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    await ref.read(leadListProvider.notifier).updateLeadStatus(
          widget.leadId,
          newStatus,
        );
    await _loadLead();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    }
  }

  Future<void> _deleteLead() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: const Text(
            'Are you sure you want to delete this lead? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(leadListProvider.notifier).deleteLead(widget.leadId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead deleted successfully'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lead == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lead Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final lead = _lead!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditLeadScreen(lead: lead),
                ),
              );
              if (result == true) {
                await _loadLead();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteLead,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: AppSpacing.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lead.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        StatusBadge(status: lead.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildDetailRow(
                      icon: Icons.contact_phone,
                      label: 'Contact',
                      value: lead.contact,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildDetailRow(
                      icon: Icons.flag,
                      label: 'Status',
                      value: lead.status,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'Created',
                      value: _formatDate(lead.createdAt),
                    ),
                    if (lead.notes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  lead.notes,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Update Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: Lead.statusOptions.map((status) {
                final isCurrentStatus = status == lead.status;
                return ElevatedButton(
                  onPressed:
                      isCurrentStatus ? null : () => _updateStatus(status),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentStatus
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    foregroundColor: isCurrentStatus ? Colors.white : null,
                  ),
                  child: Text(status),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
