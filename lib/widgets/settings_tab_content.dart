import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/theme_provider.dart';
import '../controllers/lead_provider.dart';
import '../themes/app_themes.dart';
import 'section_header.dart';

class SettingsTabContent extends ConsumerWidget {
  const SettingsTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return SingleChildScrollView(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Information'),
                  subtitle: const Text('Version 1.0.0'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('App Information'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mini Lead Manager'),
                            SizedBox(height: 8),
                            Text('Version: 1.0.0'),
                            SizedBox(height: 8),
                            Text('A simple CRM for managing your leads'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('Export JSON'),
                  subtitle: const Text('Export all leads as JSON'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    try {
                      final dbService = ref.read(leadDbServiceProvider);
                      final jsonString = await dbService.exportLeadsAsJson();
                      if (context.mounted) {
                        _showJsonDialog(context, jsonString);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error exporting leads: $e'),
                            backgroundColor: AppColors.errorRed,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Data Storage'),
                  subtitle: const Text('Local SQLite database'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Data Storage'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Storage Type: Local SQLite Database'),
                            SizedBox(height: 8),
                            Text(
                                'All your lead data is stored locally on your device.'),
                            SizedBox(height: 8),
                            Text('No data is sent to external servers.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : themeMode == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.brightness_auto,
                  ),
                  title: const Text('Theme'),
                  subtitle: Text(
                    themeMode == ThemeMode.dark
                        ? 'Dark mode'
                        : themeMode == ThemeMode.light
                            ? 'Light mode'
                            : 'System default',
                  ),
                  trailing: PopupMenuButton<ThemeMode>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (ThemeMode mode) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ThemeMode>>[
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.light,
                        child: Row(
                          children: [
                            Icon(
                              Icons.light_mode,
                              size: 20,
                              color: themeMode == ThemeMode.light
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('Light'),
                            if (themeMode == ThemeMode.light) ...[
                              const Spacer(),
                              Icon(
                                Icons.check,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.dark,
                        child: Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              size: 20,
                              color: themeMode == ThemeMode.dark
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('Dark'),
                            if (themeMode == ThemeMode.dark) ...[
                              const Spacer(),
                              Icon(
                                Icons.check,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.system,
                        child: Row(
                          children: [
                            Icon(
                              Icons.brightness_auto,
                              size: 20,
                              color: themeMode == ThemeMode.system
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('System'),
                            if (themeMode == ThemeMode.system) ...[
                              const Spacer(),
                              Icon(
                                Icons.check,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Help & Support'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How to use Mini Lead Manager:',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('• Add new leads using the + button'),
                            const Text('• Filter leads by status'),
                            const Text(
                                '• View lead details by tapping on a lead'),
                            const Text('• Update lead status and information'),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                                'For support, please contact the developer.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('About'),
                  subtitle: const Text('Mini Lead Manager'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('About'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mini Lead Manager',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            const Text('Version 1.0.0'),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                              'A simple and efficient CRM application for managing your leads locally.',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('Built with Flutter'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Text(
              'Mini Lead Manager',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              'A simple CRM for managing your leads',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJsonDialog(BuildContext context, String jsonString) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: AppSpacing.paddingLG,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.md),
                    topRight: Radius.circular(AppRadius.md),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.code_outlined),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Exported Leads (JSON)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy to clipboard',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: jsonString));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('JSON copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // JSON Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingLG,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppRadius.md),
                      bottomRight: Radius.circular(AppRadius.md),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: SelectableText(
                        jsonString,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Footer
              Container(
                padding: AppSpacing.paddingLG,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: jsonString));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('JSON copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
