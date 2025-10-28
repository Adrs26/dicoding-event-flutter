import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_project/core/setup_locator.dart';
import 'package:test_project/data/repositories/event_repository.dart';
import 'package:test_project/logic/event_bloc.dart';
import 'package:test_project/presentation/pages/upcoming_page.dart';
import 'package:test_project/presentation/pages/finished_page.dart';
import 'package:test_project/presentation/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.surface,
        statusBarIconBrightness: theme.primaryColor.computeLuminance() > 0.5
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      UpcomingEventPage(
        onEventTap: (eventId) => context.push('/detail/$eventId'),
      ),
      FinishedEventPage(
        onEventTap: (eventId) => context.push('/detail/$eventId'),
      ),
      const SettingsPage(text: 'Settings'),
    ];

    List<String> pageTitles = <String>[
      'Upcoming Events',
      'Finished Events',
      'Favorite Events',
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UpcomingEventsBloc(locator<EventRepository>()),
        ),
        BlocProvider(
          create: (context) => FinishedEventsBloc(locator<EventRepository>()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            pageTitles[_selectedIndex],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          actions: [
            _selectedIndex == 0 || _selectedIndex == 1
                ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                : Container(),
          ],
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0
                      ? Icons.event_note
                      : Icons.event_note_outlined,
                ),
                label: 'Upcoming',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1
                      ? Icons.event_available
                      : Icons.event_available_outlined,
                ),
                label: 'Finished',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline,
                ),
                label: 'Favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
