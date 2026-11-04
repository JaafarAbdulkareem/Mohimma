import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_time/manage/task_cubit.dart';
import 'package:task_time/screen/task_screen.dart';
import 'package:task_time/services/notification_service.dart';
import 'package:task_time/services/task_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final TaskCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cubit = TaskCubit(TaskStorage(), NotificationService.instance)
      ..onTaskFinished = _showFinished
      ..load();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.requestPermissions();
    });
  }

  void _showFinished(String title) {
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('انتهى وقت المهمة: $title ⏰'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 15),
          action: SnackBarAction(
            label: 'إيقاف المنبه',
            textColor: Colors.white,
            onPressed: NotificationService.instance.dismissShown,
          ),
        ),
      );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Opening the app silences a ringing alarm and refreshes the countdowns.
      NotificationService.instance.dismissShown();
      _cubit.onResume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: MaterialApp(
        scaffoldMessengerKey: _messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Task Countdown',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F5F7),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const TasksScreen(),
      ),
    );
  }
}
