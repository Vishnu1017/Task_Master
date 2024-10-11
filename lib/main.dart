import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master/data/hive_data_store.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/views/home/home_view.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  Box<Task> box = await Hive.openBox<Task>(HiveDataStore.boxName);
  box.values.forEach((task) {
    if (task.createAtTime.day != DateTime.now()) {
      task.delete();
    } else {}
  });
  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError("Could ot find ancestor widget of type BaseMidget");
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task Master',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.w300,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
