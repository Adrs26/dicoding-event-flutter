import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_project/core/setup_locator.dart';
import 'package:test_project/core/theme/color_scheme.dart';
import 'package:test_project/core/theme/typography.dart';
import 'package:test_project/presentation/pages/event_detail_page.dart';
import 'package:test_project/presentation/pages/main_page.dart';
import 'package:test_project/presentation/pages/search_event_page.dart';

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
    return MaterialApp.router(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: myColorScheme,
        fontFamily: 'Inter',
        textTheme: myTextTheme,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final eventId = state.pathParameters['id'];
        return EventDetailPage(eventId: int.parse(eventId!));
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => SearchEventPage(
        onEventTap: (eventId) => context.push('/detail/$eventId'),
      ),
    )
  ]
);
