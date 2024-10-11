// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';

import 'package:task_master/extensions/space_exs.dart';
import 'package:task_master/main.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/utils/app_colors.dart';
import 'package:task_master/utils/app_str.dart';
import 'package:task_master/utils/constants.dart';
import 'package:task_master/views/tasks/components/date_time_selection.dart';
import 'package:task_master/views/tasks/components/rep_textfield.dart';
import 'package:task_master/views/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    Key? key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  }) : super(key: key);
  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;
  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String showTime(DateTime? time) {
    if (widget.task?.createAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a').format(widget.task!.createAtTime).toString();
    }
  }

  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createAtTime;
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createAtDate;
    }
  }

  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic isTaskAlreadyExistUpdate0therWiseCreate() {
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createAtTime: time,
          createAtDate: date,
          subTitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  void initState() {
    super.initState();
    _titleController = widget.titleTaskController ?? TextEditingController();
    _descriptionController =
        widget.descriptionTaskController ?? TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopSideTexts(textTheme),
                _buildMainTaskVieWActivity(textTheme, context),
                _buildBottomSideButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              : MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  height: 55,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      5.w,
                      const Text(
                        AppStr.deleteTask,
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdate0therWiseCreate();
            },
            minWidth: 150,
            height: 55,
            color: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.addNewTask
                  : AppStr.updateTaskString,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTaskVieWActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),
          RepTextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter task title', // Adjust the hint as needed
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),
          15.h,
          RepTextField(
            controller: _descriptionController,
            isForDescription: true,
            decoration: InputDecoration(
              hintText: 'Enter task description', // Adjust the hint as needed
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (String inputSubTitle) {
              subtitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subtitle = inputSubTitle;
            },
          ),
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                        height: 280,
                        child: TimePickerWidget(
                          initDateTime: showDateAsDateTime(time),
                          onChange: (_, ___) {},
                          dateFormat: 'HH:mm',
                          onConfirm: (dateTime, ____) {
                            setState(() {
                              if (widget.task?.createAtTime == null) {
                                time = dateTime;
                              } else {
                                widget.task!.createAtTime = dateTime;
                              }
                            });
                          },
                        ),
                      ));
            },
            title: AppStr.timeString,
            time: showTime(time),
          ),
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(date),
                  onConfirm: (dateTime, _) {
                setState(() {
                  if (widget.task?.createAtDate == null) {
                    date = dateTime;
                  } else {
                    widget.task!.createAtDate = dateTime;
                  }
                });
              });
            },
            title: AppStr.dateString,
            isTime: true,
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
              text: isTaskAlreadyExist()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
              style: textTheme.titleLarge,
              children: const [
                TextSpan(
                  text: AppStr.taskStrnig,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
