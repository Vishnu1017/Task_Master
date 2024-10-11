import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:task_master/main.dart';
import 'package:task_master/utils/app_str.dart';

String lottieURL = "assets/lottie/1.json";

dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must fill all fields!",
    corner: 20,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must edite tasks then try to update it!",
    corner: 20,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message:
        "There is no Task For Delete! \n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

dynamic deleteAllTasks(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: AppStr.areYouSure,
      message:
          "Do you really want to delete all task? You will not able to undo this action!",
      confirmButtonText: "Yes",
      cancelButtonText: "No", onTapConfirm: () {
    BaseWidget.of(context).dataStore.box.clear();
    Navigator.pop(context);
  }, onTapCancel: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error, barrierDismissible: false);
}
