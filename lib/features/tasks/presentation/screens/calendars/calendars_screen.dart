import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/presentation/screens/calendars/daily_calendar_screen.dart';
import 'package:better_io/features/tasks/presentation/screens/calendars/monthly_calendars_screen.dart';
import 'package:better_io/features/tasks/presentation/screens/calendars/weekly_calendars_screen.dart';
import 'package:better_io/features/tasks/presentation/screens/calendars/schedule_calendar_screen.dart';

class CalendarsScreen extends StatefulWidget {
  const CalendarsScreen({Key? key}) : super(key: key);

  @override
  State<CalendarsScreen> createState() => _CalendarsScreenState();
}

class _CalendarsScreenState extends State<CalendarsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Updated length to 5
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TODO: Move tab logic into app navigation instead of handling it here.
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Schedule'),
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
              Tab(text: 'List'),
            ],
            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
            unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ScheduleCalendarScreen(),
                DailyCalendarScreen(),
                WeeklyCalendarScreen(),
                MonthlyCalendarScreen(),
                Center(child: Text('List View')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
