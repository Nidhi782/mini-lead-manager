import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/animated_lead_list.dart';

class LeadsTabContent extends ConsumerWidget {
  const LeadsTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        SearchBarWidget(),
        FilterBar(),
        Expanded(
          child: AnimatedLeadList(),
        ),
      ],
    );
  }
}
