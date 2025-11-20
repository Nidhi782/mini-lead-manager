import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/lead_provider.dart';
import '../themes/app_themes.dart';
import 'section_header.dart';
import 'dashboard_card.dart';

class DashboardTabContent extends ConsumerWidget {
  const DashboardTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(allLeadsProvider);

    return leadsAsync.when(
      data: (leads) {
        // Calculate statistics
        final totalLeads = leads.length;
        final newLeads = leads.where((l) => l.status == 'New').length;
        final contactedLeads =
            leads.where((l) => l.status == 'Contacted').length;
        final convertedLeads =
            leads.where((l) => l.status == 'Converted').length;
        final lostLeads = leads.where((l) => l.status == 'Lost').length;
        final conversionRate =
            totalLeads > 0 ? (convertedLeads / totalLeads * 100) : 0.0;

        return SingleChildScrollView(
          padding: AppSpacing.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Overview'),
              // Statistics Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: 1.5,
                children: [
                  DashboardCard(
                    title: 'Total Leads',
                    value: totalLeads.toString(),
                    icon: Icons.people_outline,
                    color: AppColors.primaryBlue,
                  ),
                  DashboardCard(
                    title: 'Conversion Rate',
                    value: '${conversionRate.toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    color: AppColors.accentGreen,
                  ),
                  DashboardCard(
                    title: 'New Leads',
                    value: newLeads.toString(),
                    icon: Icons.fiber_new,
                    color: AppColors.primaryBlue,
                  ),
                  DashboardCard(
                    title: 'Contacted',
                    value: contactedLeads.toString(),
                    icon: Icons.phone,
                    color: AppColors.warningOrange,
                  ),
                  DashboardCard(
                    title: 'Converted',
                    value: convertedLeads.toString(),
                    icon: Icons.check_circle_outline,
                    color: AppColors.accentGreen,
                  ),
                  DashboardCard(
                    title: 'Lost',
                    value: lostLeads.toString(),
                    icon: Icons.cancel_outlined,
                    color: AppColors.errorRed,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Status Distribution'),
              Card(
                child: Padding(
                  padding: AppSpacing.paddingLG,
                  child: Column(
                    children: [
                      _StatusBar(
                        label: 'New',
                        count: newLeads,
                        total: totalLeads,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _StatusBar(
                        label: 'Contacted',
                        count: contactedLeads,
                        total: totalLeads,
                        color: AppColors.warningOrange,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _StatusBar(
                        label: 'Converted',
                        count: convertedLeads,
                        total: totalLeads,
                        color: AppColors.accentGreen,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _StatusBar(
                        label: 'Lost',
                        count: lostLeads,
                        total: totalLeads,
                        color: AppColors.errorRed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Error loading dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.errorRed,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
