import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'theme/app_theme.dart';
import 'providers/task_provider.dart';
import 'providers/challenge_provider.dart';
import 'services/notification_service.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/challenges/challenges_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  NotificationService.navigatorKey = navigatorKey;
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final provider = TaskProvider()..loadTasks();
          // Lets NotificationService resolve a task by id when an alarm
          // notification is tapped or a snooze action button is pressed.
          NotificationService.taskLookup = (id) {
            final matches = provider.tasks.where((t) => t.id == id);
            return matches.isEmpty ? null : matches.first;
          };
          return provider;
        }),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()..loadChallenges()),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'TaskFlow AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(lightDynamic),
            darkTheme: AppTheme.dark(darkDynamic),
            themeMode: ThemeMode.system,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}

/// Root navigation shell: bottom navigation across the 5 primary modules.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    CalendarScreen(),
    ChallengesScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'ዳሽቦርድ'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'ካላንደር'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'ቻሌንጅ'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'ሪፖርት'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'ማስተካከያ'),
        ],
      ),
    );
  }
}
