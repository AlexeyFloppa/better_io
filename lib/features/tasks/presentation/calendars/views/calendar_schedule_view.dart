import 'package:better_io/features/tasks/data/data_sources/sfcalandar_data_source.dart';
import 'package:better_io/shared/widgets/sheets/bottom_task_sheet.dart';
import 'package:better_io/features/tasks/presentation/calendars/widgets/schedule_appoinment_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../view_models/calendars_view_model.dart';

class CalendarScheduleView extends StatefulWidget {
  const CalendarScheduleView({super.key});

  @override
  State<CalendarScheduleView> createState() => _CalendarScheduleViewState();
}

class _CalendarScheduleViewState extends State<CalendarScheduleView> {
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
                      appointmentItemHeight: 68,
                      monthHeaderSettings: MonthHeaderSettings(height: 0),
                      weekHeaderSettings: WeekHeaderSettings(height: 0),
                    ),
                    onLongPress: (details) {
                      if (details.appointments?.isNotEmpty ?? false) {
                        final appointment =
                            details.appointments!.first as Appointment;
                        final taskId = appointment.id.toString();
                        final appointmentDate = appointment.startTime
                            .add(const Duration(minutes: 60));

                        showModalBottomSheet(
                          context: context,
                          builder: (_) => BottomTaskSheet(
                            onTaskRemove: () async {
                              await vm.deleteTask(taskId);
                            },
                            onTaskEdit: () async {
                              await vm.editTask(context, taskId);
                            },
                            onRecurrencyRemove: () async {
                              await vm.deleteRecurrency(
                                  taskId, appointmentDate);
                            },
                          ),
                        );
                      }
                    },
                    dataSource: SfCalandarDataSource(vm.appointments),
                  ),
          );
        },
      ),
    );
  }
}
