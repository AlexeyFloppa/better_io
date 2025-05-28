import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../view_models/calendars_view_model.dart';

class CalendarScheduleScreen extends StatelessWidget {
  const CalendarScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarsViewModel(),
      child: Consumer<CalendarsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfCalendar(
                    headerHeight: 0,
                    view: CalendarView.schedule,
                    scheduleViewSettings: const ScheduleViewSettings(
                      hideEmptyScheduleWeek: true,
                      monthHeaderSettings: MonthHeaderSettings(height: 0),
                      weekHeaderSettings: WeekHeaderSettings(height: 0),
                    ),
                    dataSource: TaskCalendarDataSource(viewModel.appointments),
                  ),
          );
        },
      ),
    );
  }
}

class TaskCalendarDataSource extends CalendarDataSource {
  TaskCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
