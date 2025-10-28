import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/setup_locator.dart';
import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/data/repositories/event_repository.dart';
import 'package:test_project/logic/event_bloc.dart';
import 'package:test_project/logic/event_intent.dart';
import 'package:test_project/logic/event_state.dart';
import 'package:test_project/utils/formatter.dart';

class EventDetailPage extends StatelessWidget {
  final int eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DetailEventBloc(locator<EventRepository>(), eventId)
            ..add(FetchDetailEvent()),
      child: BlocBuilder<DetailEventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SingleEventSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Event Detail',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                surfaceTintColor: Theme.of(context).colorScheme.surface,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(color: Colors.grey.shade300, height: 1),
                ),
              ),
              body: EventDetailContent(eventDetail: state.event),
              bottomNavigationBar: const EventDetailBottomBar(),
            );
          }
          if (state is EventError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press refresh to load users'));
        },
      ),
    );
  }
}

class EventDetailContent extends StatelessWidget {
  final EventDetailModel eventDetail;

  const EventDetailContent({super.key, required this.eventDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: eventDetail.mediaCover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 8,
            ),
            child: Expanded(
              child: Text(
                eventDetail.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          EventDetailData(title: 'Owner Name:', value: eventDetail.ownerName),
          EventDetailData(title: 'Category:', value: eventDetail.category),
          EventDetailData(
            title: 'Datetime:',
            value: Formatter.dateFormat(eventDetail.beginTime),
          ),
          EventDetailData(title: 'Location:', value: eventDetail.cityName),
          EventDetailData(
            title: 'Quota remaining:',
            value: (eventDetail.quota - eventDetail.registrants).toString(),
          ),
          const SizedBox(height: 8),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Expanded(
              child: Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Expanded(
              child: Text(
                Formatter.parseHtmlToText(eventDetail.description),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailData extends StatelessWidget {
  final String title;
  final String value;

  const EventDetailData({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailBottomBar extends StatelessWidget {
  const EventDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {},
                child: Text(
                  'Go to website',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_outline,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
