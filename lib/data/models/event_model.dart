class EventCoverModel {
  final int id;
  final String imageLogo;
  final String name;
  final String beginTime;

  EventCoverModel({
    required this.id,
    required this.imageLogo,
    required this.name,
    required this.beginTime,
  });

  factory EventCoverModel.fromJson(Map<String, dynamic> json) =>
      EventCoverModel(
        id: json['id'],
        imageLogo: json['imageLogo'],
        name: json['name'],
        beginTime: json['beginTime'],
      );
}

class EventDetailModel {
  final int id;
  final String imageLogo;
  final String mediaCover;
  final String name;
  final String ownerName;
  final String category;
  final String beginTime;
  final String cityName;
  final int quota;
  final int registrants;
  final String description;
  final String link;

  EventDetailModel({
    required this.id,
    required this.imageLogo,
    required this.mediaCover,
    required this.name,
    required this.ownerName,
    required this.category,
    required this.beginTime,
    required this.cityName,
    required this.quota,
    required this.registrants,
    required this.description,
    required this.link,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) =>
      EventDetailModel(
        id: json['id'],
        imageLogo: json['imageLogo'],
        mediaCover: json['mediaCover'],
        name: json['name'],
        ownerName: json['ownerName'],
        category: json['category'],
        beginTime: json['beginTime'],
        cityName: json['cityName'],
        quota: json['quota'],
        registrants: json['registrants'],
        description: json['description'],
        link: json['link'],
      );
}
