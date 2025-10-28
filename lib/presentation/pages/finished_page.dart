import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/logic/event_bloc.dart';
import 'package:test_project/logic/event_intent.dart';
import 'package:test_project/logic/event_state.dart';
import 'package:test_project/presentation/widgets/event_item.dart';

class FinishedPage extends StatelessWidget {
  const FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FinishedEventsBloc>().add(FetchFinishedEvents());

    return BlocBuilder<FinishedEventsBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is EventSuccess) {
          return ListView.builder(
            key: const PageStorageKey('finished_events_list'),
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return EventItem(
                image: event.mediaCover,
                title: event.name,
                datetime: event.beginTime,
              );
            },
          );
        }
        if (state is EventError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Press refresh to load users'));
      },
    );
  }
}
