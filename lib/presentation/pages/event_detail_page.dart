import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/local/event_entity.dart';
import 'package:test_project/di/setup_locator.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';
import 'package:test_project/presentation/bloc/event_intent.dart';
import 'package:test_project/presentation/bloc/event_state.dart';
import 'package:test_project/utils/formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late int eventId;
  bool? isFavorite;

  @override
  void initState() {
    super.initState();
    eventId = widget.eventId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<DetailEventBloc>()..add(FetchDetailEvent(eventId)),
      child: BlocBuilder<DetailEventBloc, EventState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SuccessState<EventDetailBlocModel>) {
            isFavorite ??= state.item!.isFavorite;

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
              body: _EventDetailContent(eventDetail: state.item!),
              bottomNavigationBar: _EventDetailBottomBar(
                link: state.item!.link,
                isFavorite: isFavorite!,
                onFavoriteClick: () {
                  setState(() {
                    isFavorite = !isFavorite!;
                    context.read<DetailEventBloc>().add(
                      HandleFavoriteEvent(
                        EventEntity(
                          id: state.item!.id,
                          name: state.item!.name,
                          image: state.item!.imageLogo,
                          beginTime: state.item!.beginTime,
                        ),
                      ),
                    );
                    context.read<FavoriteEventsBloc>().add(
                      GetAllFavoriteEvents(),
                    );
                  });
                },
              ),
            );
          }
          if (state is ErrorState) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press refresh to load users'));
        },
      ),
    );
  }
}

class _EventDetailContent extends StatelessWidget {
  final EventDetailBlocModel eventDetail;

  const _EventDetailContent({required this.eventDetail});

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
          _EventDetailData(title: 'Owner Name:', value: eventDetail.ownerName),
          _EventDetailData(title: 'Category:', value: eventDetail.category),
          _EventDetailData(title: 'Datetime:', value: eventDetail.formattedDate),
          _EventDetailData(title: 'Location:', value: eventDetail.cityName),
          _EventDetailData(
            title: 'Quota remaining:',
            value: eventDetail.remainingQuota,
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
                Formatter.htmlToText(eventDetail.description),
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

class _EventDetailData extends StatelessWidget {
  final String title;
  final String value;

  const _EventDetailData({required this.title, required this.value});

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

class _EventDetailBottomBar extends StatelessWidget {
  final String link;
  final bool isFavorite;
  final Function onFavoriteClick;

  const _EventDetailBottomBar({
    required this.link,
    required this.isFavorite,
    required this.onFavoriteClick,
  });

  Future<void> _openWebsite(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
                onPressed: () async {
                  _openWebsite(link);
                },
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
              onPressed: () {
                onFavoriteClick();
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
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