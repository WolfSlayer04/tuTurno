enum QueueStatus { open, busy, closed }

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String imageUrl;
  final double rating;
  final String distance;
  final int waitMinutes;
  final int peopleWaiting;
  final QueueStatus queueStatus;
  final String location;
  final String schedule;
  final String description;
  final List<String> tags;
  final double latitude;
  final double longitude;

  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.waitMinutes,
    required this.peopleWaiting,
    required this.queueStatus,
    required this.location,
    required this.schedule,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.tags = const [],
  });

  Restaurant copyWith({
    int? waitMinutes,
    int? peopleWaiting,
    QueueStatus? queueStatus,
  }) {
    return Restaurant(
      id: id,
      name: name,
      category: category,
      subcategory: subcategory,
      imageUrl: imageUrl,
      rating: rating,
      distance: distance,
      waitMinutes: waitMinutes ?? this.waitMinutes,
      peopleWaiting: peopleWaiting ?? this.peopleWaiting,
      queueStatus: queueStatus ?? this.queueStatus,
      location: location,
      schedule: schedule,
      description: description,
      latitude: latitude,
      longitude: longitude,
      tags: tags,
    );
  }

  String get queueLabel {
    switch (queueStatus) {
      case QueueStatus.open:
        return 'Fila abierta';
      case QueueStatus.busy:
        return 'Alta demanda';
      case QueueStatus.closed:
        return 'Fila cerrada';
    }
  }
}
