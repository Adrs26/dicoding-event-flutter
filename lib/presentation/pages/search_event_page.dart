import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/di/setup_locator.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';
import 'package:test_project/presentation/bloc/event_intent.dart';
import 'package:test_project/presentation/bloc/event_state.dart';
import 'package:test_project/presentation/widgets/event_item.dart';

class SearchEventPage extends StatelessWidget {
  final Function(int) onEventTap;

  const SearchEventPage({super.key, required this.onEventTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<EventsByQueryBloc>()..add(FetchEventsByQuery('')),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: _SearchEventAppBar(),
        ),
        body: BlocBuilder<EventsByQueryBloc, EventState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SuccessState<EventCoverModel>) {
              return ListView.builder(
                key: const PageStorageKey('search_events_list'),
                itemCount: state.items?.length,
                itemBuilder: (context, index) {
                  final event = state.items?[index];
                  return EventItem(
                    image: event?.imageLogo ?? '',
                    title: event?.name ?? '',
                    datetime: event?.beginTime ?? '',
                    onTap: () => onEventTap(event?.id ?? 0),
                  );
                },
              );
            }
            if (state is ErrorState) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Press refresh to load users'));
          },
        ),
      ),
    );
  }
}

class _SearchEventAppBar extends StatefulWidget {
  @override
  State<_SearchEventAppBar> createState() => _SearchEventAppBarState();
}

class _SearchEventAppBarState extends State<_SearchEventAppBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  static const _debounceDuration = Duration(milliseconds: 500);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(_debounceDuration, () {
      if (query.isNotEmpty) {
        context.read<EventsByQueryBloc>().add(FetchEventsByQuery(query));
      } else {
        context.read<EventsByQueryBloc>().add(FetchEventsByQuery(''));
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(left: 4, right: 16, top: 40, bottom: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search your favorite event',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          context.read<EventsByQueryBloc>().add(
                            FetchEventsByQuery(''),
                          );
                          setState(() {});
                        },
                      )
                    : null,
              ),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 14),
              onChanged: _onSearchChanged,
            ),
          ),
        ],
      ),
    );
  }
}
