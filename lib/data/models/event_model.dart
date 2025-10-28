class EventCoverModel {
  final int id;
  final String mediaCover;
  final String name;
  final String beginTime;

  EventCoverModel({
    required this.id,
    required this.mediaCover,
    required this.name,
    required this.beginTime,
  });

  factory EventCoverModel.fromJson(Map<String, dynamic> json) =>
      EventCoverModel(
        id: json['id'],
        mediaCover: json['mediaCover'],
        name: json['name'],
        beginTime: json['beginTime'],
      );
}
