import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/animated_lead_list.dart';
import 'add_lead_screen.dart';

class LeadListScreen extends ConsumerWidget {
  const LeadListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Lead Manager'),
        elevation: 0,
      ),
      body: const Column(
        children: [
          SearchBarWidget(),
          FilterBar(),
          Expanded(
            child: AnimatedLeadList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddLeadScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Lead'),
      ),
    );
  }
}
