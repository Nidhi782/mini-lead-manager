import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/lead_provider.dart';
import '../models/lead_model.dart';
import '../themes/app_themes.dart';

class EditLeadScreen extends ConsumerStatefulWidget {
  final Lead lead;

  const EditLeadScreen({
    super.key,
    required this.lead,
  });

  @override
  ConsumerState<EditLeadScreen> createState() => _EditLeadScreenState();
}

class _EditLeadScreenState extends ConsumerState<EditLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _notesController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lead.name);
    _contactController = TextEditingController(text: widget.lead.contact);
    _notesController = TextEditingController(text: widget.lead.notes);
    _selectedStatus = widget.lead.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateLead() async {
    if (_formKey.currentState!.validate()) {
      final updatedLead = widget.lead.copyWith(
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        notes: _notesController.text.trim(),
        status: _selectedStatus,
      );

      await ref.read(leadListProvider.notifier).updateLead(updatedLead);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead updated successfully'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lead'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter lead name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact *',
                  hintText: 'Phone or Email',
                  prefixIcon: Icon(Icons.contact_phone),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: Lead.statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Additional notes (optional)',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _updateLead,
                style: ElevatedButton.styleFrom(
                  padding: AppSpacing.paddingVerticalLG,
                ),
                child: Text(
                  'Update Lead',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
