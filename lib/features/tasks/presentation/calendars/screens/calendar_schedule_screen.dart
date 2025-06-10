import 'package:better_io/features/tasks/data/data_sources/task_data_source.dart';
import 'package:better_io/features/tasks/presentation/calendars/widgets/bottom_task_sheet.dart';
import 'package:better_io/features/tasks/presentation/calendars/widgets/schedule_appoinment_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../view_models/calendars_view_model.dart';

class CalendarScheduleScreen extends StatefulWidget {
  const CalendarScheduleScreen({super.key});

  @override
  State<CalendarScheduleScreen> createState() => _CalendarScheduleScreenState();
}

class _CalendarScheduleScreenState extends State<CalendarScheduleScreen> {
  late final CalendarsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CalendarsViewModel(); // initialize once
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<CalendarsViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfCalendar(
                    headerHeight: 0,
                    view: CalendarView.schedule,
                    appointmentBuilder: scheduleAppointmentBuilder,
                    scheduleViewSettings: const ScheduleViewSettings(
                      hideEmptyScheduleWeek: true,
                      monthHeaderSettings: MonthHeaderSettings(height: 0),
                      weekHeaderSettings: WeekHeaderSettings(height: 0),
                    ),
                    onLongPress: (details) {
                      if (details.appointments?.isNotEmpty ?? false) {
                        final appointment =
                            details.appointments!.first as Appointment;
                        final taskId = appointment.id.toString();
                        final recurrenceStart = appointment.startTime;

                        showModalBottomSheet(
                          context: context,
                          builder: (_) => BottomTaskSheet(
                            onTaskRemove: () async {
                              await vm.deleteTask(taskId);
                            },
                            onEdit: () async {
                              await vm.editTask(context, taskId);
                            },
                          ),
                        );
                      }
                    },
                    dataSource: TaskDataSource(vm.appointments),
                  ),
          );
        },
      ),
    );
  }
}
