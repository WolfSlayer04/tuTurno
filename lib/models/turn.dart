enum TurnStatus {
  waiting,
  upcoming,
  called,
  attended,
  cancelled,
  noShow,
}

extension TurnStatusX on TurnStatus {
  String get label {
    switch (this) {
      case TurnStatus.waiting:
        return 'Esperando';
      case TurnStatus.upcoming:
        return 'Próximo';
      case TurnStatus.called:
        return 'Llamado';
      case TurnStatus.attended:
        return 'Atendido';
      case TurnStatus.cancelled:
        return 'Cancelado';
      case TurnStatus.noShow:
        return 'No presentado';
    }
  }

  bool get isActive =>
      this == TurnStatus.waiting ||
      this == TurnStatus.upcoming ||
      this == TurnStatus.called;
}

class Turn {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String restaurantAddress;
  final String turnNumber;
  final int partySize;
  final int position;
  final int totalInQueue;
  final int estimatedMinutes;
  final TurnStatus status;
  final DateTime joinedAt;
  final DateTime lastUpdated;
  final int? waitDurationMinutes;
  final double latitude;
  final double longitude;

  const Turn({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantAddress,
    required this.turnNumber,
    required this.partySize,
    required this.position,
    required this.totalInQueue,
    required this.estimatedMinutes,
    required this.status,
    required this.joinedAt,
    required this.lastUpdated,
    required this.latitude,
    required this.longitude,
    this.waitDurationMinutes,
  });

  double get progress {
    if (totalInQueue <= 0) return 1;
    final advanced = (totalInQueue - position + 1).clamp(0, totalInQueue);
    return advanced / totalInQueue;
  }

  Turn copyWith({
    int? position,
    int? totalInQueue,
    int? estimatedMinutes,
    TurnStatus? status,
    DateTime? lastUpdated,
    int? waitDurationMinutes,
  }) {
    return Turn(
      id: id,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
      restaurantAddress: restaurantAddress,
      turnNumber: turnNumber,
      partySize: partySize,
      position: position ?? this.position,
      totalInQueue: totalInQueue ?? this.totalInQueue,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      status: status ?? this.status,
      joinedAt: joinedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      waitDurationMinutes: waitDurationMinutes ?? this.waitDurationMinutes,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
