import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/local/event_entity.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';
import 'package:test_project/presentation/bloc/event_intent.dart';
import 'package:test_project/presentation/bloc/event_state.dart';
import 'package:test_project/presentation/widgets/event_item.dart';

class FavoriteEventPage extends StatefulWidget {
  final Function(int) onEventTap;

  const FavoriteEventPage({super.key, required this.onEventTap});

  @override
  State<FavoriteEventPage> createState() => _FavoriteEventPageState();
}

class _FavoriteEventPageState extends State<FavoriteEventPage> {
  Function(int)? onEventTap;

  @override
  void initState() {
    super.initState();
    onEventTap = widget.onEventTap;
    context.read<FavoriteEventsBloc>().add(GetAllFavoriteEvents());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteEventsBloc, EventState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SuccessState<EventEntity>) {
          if (state.items!.isNotEmpty) {
            return ListView.builder(
              key: const PageStorageKey('favorite_events_list'),
              itemCount: state.items?.length,
              itemBuilder: (context, index) {
                final event = state.items?[index];
                return EventItem(
                  image: event?.image ?? '',
                  title: event?.name ?? '',
                  datetime: event?.beginTime ?? '',
                  onTap: () => onEventTap!(event?.id ?? 0),
                );
              },
            );
          } else {
            return const Center(child: Text('No favorite events'));
          }
        }
        if (state is ErrorState) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Press refresh to load users'));
      },
    );
  }
}
