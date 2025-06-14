import 'package:better_io/features/example_screens.dart';
import 'package:better_io/features/home/home_screen.dart';
import 'package:better_io/features/tasks/presentation/calendars/screens/calendar_daily_screen.dart';
import 'package:better_io/features/tasks/presentation/calendars/screens/calendar_monthly_screen.dart';
import 'package:better_io/features/tasks/presentation/calendars/screens/calendar_schedule_screen.dart';
import 'package:better_io/features/tasks/presentation/calendars/screens/calendar_weekly_screen.dart';
import 'package:better_io/features/tasks/presentation/manage_task/screens/manage_task_screen.dart';
import 'package:better_io/shared/widgets/fab_button.dart';
import 'package:flutter/material.dart';

import '../domain/models/section_nav_data.dart';
import '../domain/models/module_nav_data.dart';
import '../domain/models/submodule_nav_data.dart';

final List<SectionNavData> appSections = [
  SectionNavData(
    id: 'home',
    title: 'Home',
    icon: Icons.home,
    modules: [
      ModuleNavData(
        id: 'home_main',
        title: 'Main',
        icon: Icons.home,
        screen: HomeScreen(),
      ),
      ModuleNavData(
        id: 'home_favorites',
        title: 'Favorites',
        icon: Icons.star,
        screen: ExampleScreen2(),
      ),
      ModuleNavData(
        id: 'home_settings',
        title: 'Settings',
        icon: Icons.settings,
        screen: ExampleScreen3(),
      ),
    ],
  ),
  SectionNavData(
    id: 'tasks',
    title: 'Tasks',
    icon: Icons.calendar_today,
    modules: [
      ModuleNavData(
          id: 'tasks-calendar',
          title: 'Calendar',
          icon: Icons.calendar_today,
          submodules: [
            SubmoduleNavData(
                id: 'tasks-schedule-calendar',
                title: 'Schedule',
                icon: Icons.schedule,
                screen: CalendarScheduleScreen()),
            SubmoduleNavData(
                id: 'tasks-daily-calendar',
                title: 'Daily',
                icon: Icons.calendar_view_day,
                screen: CalendarDailyScreen()),
            SubmoduleNavData(
                id: 'tasks-weekly-calendar',
                title: 'Weekly',
                icon: Icons.calendar_view_week,
                screen: CalendarWeeklyScreen()),
            SubmoduleNavData(
                id: 'tasks-monthly-calendar',
                title: 'Monthly',
                icon: Icons.calendar_view_month,
                screen: CalendarMonthlyScreen()),
          ],
          bottomButton: FABButton(
            onTap: (context) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ManageTaskScreen()),
              );
            },
          )),
      ModuleNavData(
        id: 'tasks-challenges',
        title: 'Challenges',
        icon: Icons.extension,
        screen: ExampleScreen2(),
      ),
      ModuleNavData(
        id: 'tasks-analysis',
        title: 'Analysis',
        icon: Icons.analytics,
        screen: ExampleScreen3(),
      ),
    ],
  ),
  SectionNavData(
    id: 'notes',
    title: 'Notes',
    icon: Icons.note,
    modules: [
      ModuleNavData(
        id: 'notes_example1',
        title: 'Example 1',
        icon: Icons.assignment,
        screen: ExampleScreen1(),
      ),
      ModuleNavData(
        id: 'notes_example2',
        title: 'Example 2',
        icon: Icons.assignment,
        screen: ExampleScreen2(),
      ),
      ModuleNavData(
        id: 'notes_example3',
        title: 'Example 3',
        icon: Icons.assignment,
        screen: ExampleScreen3(),
      ),
    ],
  ),
  SectionNavData(
    id: 'courses',
    title: 'Courses',
    icon: Icons.book,
    modules: [
      ModuleNavData(
        id: 'course_example1',
        title: 'Example 1',
        icon: Icons.assignment,
        screen: ExampleScreen1(),
      ),
      ModuleNavData(
        id: 'course_example2',
        title: 'Example 2',
        icon: Icons.assignment,
        screen: ExampleScreen2(),
      ),
      ModuleNavData(
        id: 'course_example3',
        title: 'Example 3',
        icon: Icons.assignment,
        screen: ExampleScreen3(),
      ),
    ],
  ),
  SectionNavData(
    id: 'community',
    title: 'Community',
    icon: Icons.people,
    modules: [
      ModuleNavData(
        id: 'community_example1',
        title: 'Example 1',
        icon: Icons.assignment,
        screen: ExampleScreen1(),
      ),
      ModuleNavData(
        id: 'community_example2',
        title: 'Example 2',
        icon: Icons.assignment,
        screen: ExampleScreen2(),
      ),
      ModuleNavData(
        id: 'community_example3',
        title: 'Example 3',
        icon: Icons.assignment,
        screen: ExampleScreen3(),
      ),
    ],
  ),
];
