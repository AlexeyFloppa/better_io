// manage_task_screen.dart
import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/basic_block_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/recurrence_block_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/views/blocks/task_repeat_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/task/set_task.dart';
import 'package:better_io/features/tasks/data/repositories/task_repository.dart';
import 'package:better_io/features/tasks/presentation/task_management/view_models/manage_task_view_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/views/blocks/task_basic_block.dart';

class ManageTaskView extends StatelessWidget {
  final Task? task;
  const ManageTaskView({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repository = TaskRepository(Hive.box('tasks'));

        final vm = ManageTaskViewModel()
          ..setTaskUseCase(SetTaskUseCase(repository));
        if (task != null) vm.loadFromTask(task!);
        return vm;
      },
      child: const _ManageTaskViewBody(),
    );
  }
}

class _ManageTaskViewBody extends StatelessWidget {
  const _ManageTaskViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ManageTaskViewModel>();
    final basicBm = vm.basicBm;
    final recurrenceBm = vm.recurrenceBm;
    final disabledColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withAlpha((Theme.of(context).colorScheme.onSurface.a * 0.38).round());

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Task')),
      body: ListView(
        children: [
          ChangeNotifierProvider.value(
            value: basicBm,
            child: Consumer<BasicBlockModel>(
              builder: (context, bm, _) =>
                  TaskBasicBlock(bm: bm, disabledColor: disabledColor),
            ),
          ),
          ChangeNotifierProvider.value(
            value: recurrenceBm,
            child: Consumer<RecurrenceBlockModel>(
              builder: (context, bm, _) =>
                  TaskRepeatBlock(bm: bm, disabledColor: disabledColor),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.saveTask(context),
        child: const Icon(Icons.save),
      ),
    );
  }
}
