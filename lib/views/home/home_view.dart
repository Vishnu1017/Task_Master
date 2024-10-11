import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:task_master/extensions/space_exs.dart';
import 'package:task_master/main.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/utils/app_colors.dart';
import 'package:task_master/utils/app_str.dart';
import 'package:task_master/utils/constants.dart';
import 'package:task_master/views/home/components/fab.dart';
import 'package:task_master/views/home/components/home_app_bar.dart';
import 'package:task_master/views/home/components/slider_drawer.dart';
import 'package:task_master/views/home/widget/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  dynamic valuefIndicator(List<Task> tasks) {
    if (tasks.isNotEmpty) {
      return tasks.length;
    } else {
      return 3;
    }
  }

  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTasks in tasks) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort((a, b) => a.createAtDate.compareTo(b.createAtDate));

          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: const Fab(),
            body: SliderDrawer(
              key: drawerKey,
              isDraggable: false,
              animationDuration: 1000,
              slider: CustomDrawer(),
              appBar: HomeAppBar(
                drawerKey: drawerKey,
              ),
              child: _buildHomeBody(
                textTheme,
                base,
                tasks,
              ),
            ),
          );
        });
  }

  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGradientCircularProgress(tasks),
                25.w,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 28,
                      ),
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length}",
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 555,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) {
                            base.dataStore.deleteTask(task: task);
                          },
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              8.w,
                              const Text(
                                AppStr.deleteTask,
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          key: Key(task.id),
                          child: TaskWidget(task: task));
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(lottieURL,
                              animate: tasks.isNotEmpty ? false : true),
                        ),
                      ),
                      FadeInUp(from: 30, child: const Text(AppStr.doneAllTask))
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCircularProgress(List<Task> tasks) {
    return CircularProgressIndicator(
      value: checkDoneTask(tasks) / valuefIndicator(tasks),
      backgroundColor: Colors.grey.shade200,
      valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
      strokeWidth: 6,
    );
  }
}
