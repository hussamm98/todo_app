import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/component.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, states) {
          var tasks = AppCubit.getCubit(context).doneTasks;
          return buildTasks(
            tasks: tasks,
          );
        });
  }
}
