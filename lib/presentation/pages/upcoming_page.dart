import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';
import 'package:test_project/presentation/bloc/event_intent.dart';
import 'package:test_project/presentation/bloc/event_state.dart';
import 'package:test_project/presentation/widgets/event_item.dart';

class UpcomingEventPage extends StatefulWidget {
  final Function(int) onEventTap;

  const UpcomingEventPage({super.key, required this.onEventTap});

  @override
  State<UpcomingEventPage> createState() => _UpcomingEventPageState();
}

class _UpcomingEventPageState extends State<UpcomingEventPage> {
  Function(int)? onEventTap;

  @override
  void initState() {
    super.initState();
    onEventTap = widget.onEventTap;
    context.read<UpcomingEventsBloc>().add(FetchUpcomingEvents());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingEventsBloc, EventState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SuccessState<EventCoverModel>) {
          if (state.items!.isNotEmpty) {
            return ListView.builder(
              key: const PageStorageKey('Upcoming_events_list'),
              itemCount: state.items?.length,
              itemBuilder: (context, index) {
                final event = state.items?[index];
                return EventItem(
                  image: event?.imageLogo ?? '',
                  title: event?.name ?? '',
                  datetime: event?.beginTime ?? '',
                  onTap: () => onEventTap!(event?.id ?? 0),
                );
              },
            );
          } else {
            return const Center(child: Text('No Upcoming events'));
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