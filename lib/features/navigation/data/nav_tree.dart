import 'package:better_io/features/example_screens.dart';
import 'package:better_io/features/home/home_screen.dart';
import 'package:better_io/features/tasks/presentation/calendars/views/calendar_daily_view.dart';
import 'package:better_io/features/tasks/presentation/calendars/views/calendar_monthly_view.dart';
import 'package:better_io/features/tasks/presentation/calendars/views/calendar_schedule_view.dart';
import 'package:better_io/features/tasks/presentation/calendars/views/calendar_weekly_view.dart';
import 'package:better_io/features/tasks/presentation/task_management/views/manage_task_view.dart';
import 'package:better_io/shared/widgets/buttons/custom_fab_button.dart';
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
          appBarActions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => ManageTaskView()),
                // );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => ManageTaskView()),
                // );
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => ManageTaskView()),
                // );
              },
            ),
          ],
          submodules: [
            SubmoduleNavData(
                id: 'tasks-schedule-calendar',
                title: 'Schedule',
                icon: Icons.schedule,
                screen: CalendarScheduleView()),
            SubmoduleNavData(
                id: 'tasks-daily-calendar',
                title: 'Daily',
                icon: Icons.calendar_view_day,
                screen: CalendarDailyView()),
            SubmoduleNavData(
                id: 'tasks-weekly-calendar',
                title: 'Weekly',
                icon: Icons.calendar_view_week,
                screen: CalendarWeeklyView()),
            SubmoduleNavData(
                id: 'tasks-monthly-calendar',
                title: 'Monthly',
                icon: Icons.calendar_view_month,
                screen: CalendarMonthlyView()),
          ],
          bottomButton: CustomFABButton(
            onTap: (context) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ManageTaskView()),
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
