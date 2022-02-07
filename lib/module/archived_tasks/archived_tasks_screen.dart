import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/component.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, states) {
          var tasks = AppCubit.getCubit(context).archivedTasks;
          return buildTasks(
            tasks: tasks,
          );
        });
  }
}
