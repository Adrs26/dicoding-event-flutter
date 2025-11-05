import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_project/di/setup_locator.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';
import 'package:test_project/presentation/pages/upcoming_page.dart';
import 'package:test_project/presentation/pages/finished_page.dart';
import 'package:test_project/presentation/pages/favorite_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    UpcomingEventPage(
      onEventTap: (eventId) => context.push('/detail/$eventId'),
    ),
    FinishedEventPage(
      onEventTap: (eventId) => context.push('/detail/$eventId'),
    ),
    FavoriteEventPage(
      onEventTap: (eventId) => context.push('/detail/$eventId'),
    ),
  ];

  List<String> get _pageTitles => [
    'Upcoming Events',
    'Finished Events',
    'Favorite Events',
  ];

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<UpcomingEventsBloc>()),
        BlocProvider(create: (_) => locator<FinishedEventsBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _pageTitles[_selectedIndex],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          actions: [
            _selectedIndex == 0 || _selectedIndex == 1
                ? IconButton(
                    onPressed: () => context.push('/search'),
                    icon: const Icon(Icons.search),
                  )
                : Container(),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: _MainPageNavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _MainPageNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const _MainPageNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: NavigationBar(
        elevation: 0,
        indicatorColor: Colors.blue.shade100,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: Icon(
              Icons.event_note,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Upcoming',
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_available_outlined),
            selectedIcon: Icon(
              Icons.event_available,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Finished',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
