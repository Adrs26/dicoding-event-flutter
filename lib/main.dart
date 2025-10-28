import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_project/core/setup_locator.dart';
import 'package:test_project/core/theme/color_scheme.dart';
import 'package:test_project/core/theme/typography.dart';
import 'package:test_project/presentation/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: myColorScheme,
        fontFamily: 'Inter',
        textTheme: myTextTheme,
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
