import 'package:flutter/material.dart';
import '../widgets/dashboard_tab_content.dart';
import '../widgets/leads_tab_content.dart';
import '../widgets/settings_tab_content.dart';
import 'add_lead_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: Row(
        children: [
          // NavigationRail for wide screens
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outlined),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Leads'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          // Main content area
          Expanded(
            child: Column(
              children: [
                // AppBar
                AppBar(
                  title: Text(_getTitle()),
                  elevation: 0,
                  actions: _selectedIndex == 1
                      ? [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddLeadScreen(),
                                ),
                              );
                            },
                            tooltip: 'Add Lead',
                          ),
                        ]
                      : null,
                ),
                // Tab content
                Expanded(
                  child: _getTabContent(),
                ),
              ],
            ),
          ),
        ],
      ),
      // BottomNavigationBar for small screens
      bottomNavigationBar: !isWideScreen
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outlined),
                  selectedIcon: Icon(Icons.people),
                  label: 'Leads',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
      // FloatingActionButton for Leads tab
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
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
            )
          : null,
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Leads';
      case 2:
        return 'Settings';
      default:
        return 'Mini Lead Manager';
    }
  }

  Widget _getTabContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardTabContent();
      case 1:
        return const LeadsTabContent();
      case 2:
        return const SettingsTabContent();
      default:
        return const DashboardTabContent();
    }
  }
}
