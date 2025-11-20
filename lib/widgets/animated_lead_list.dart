import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead_model.dart';
import '../controllers/lead_provider.dart';
import '../themes/app_themes.dart';
import 'lead_card.dart';
import '../screens/lead_details_screen.dart';

class AnimatedLeadList extends ConsumerStatefulWidget {
  const AnimatedLeadList({super.key});

  @override
  ConsumerState<AnimatedLeadList> createState() => _AnimatedLeadListState();
}

class _AnimatedLeadListState extends ConsumerState<AnimatedLeadList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent > 0 &&
        position.pixels >= position.maxScrollExtent * 0.8) {
      // User has scrolled 80% of the way
      final paginationState = ref.read(filteredLeadsProvider);
      if (paginationState.hasMore && !paginationState.isLoadingMore) {
        ref.read(leadListNotifierProvider.notifier).fetchMoreLeads();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(filteredLeadsProvider);
    final leads = paginationState.leads;

    if (paginationState.isLoading && leads.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (leads.isEmpty) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Center(
          key: const ValueKey('empty'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No leads found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tap the + button to add a new lead',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: ListView.builder(
        key: ValueKey<String>(
          leads.map((l) => l.id.toString()).join(','),
        ),
        controller: _scrollController,
        itemCount: leads.length + (paginationState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == leads.length) {
            // Loading indicator at the bottom
            return const Padding(
              padding: AppSpacing.paddingLG,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final lead = leads[index];
          return _AnimatedLeadCard(
            key: ValueKey<int?>(lead.id),
            lead: lead,
            index: index,
          );
        },
      ),
    );
  }
}

class _AnimatedLeadCard extends StatefulWidget {
  final Lead lead;
  final int index;

  const _AnimatedLeadCard({
    super.key,
    required this.lead,
    required this.index,
  });

  @override
  State<_AnimatedLeadCard> createState() => _AnimatedLeadCardState();
}

class _AnimatedLeadCardState extends State<_AnimatedLeadCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 30).clamp(0, 150)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: LeadCard(
          lead: widget.lead,
          onTap: () {
            if (widget.lead.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LeadDetailsScreen(leadId: widget.lead.id!),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
