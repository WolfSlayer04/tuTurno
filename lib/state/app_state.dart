import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/app_notification.dart';
import '../models/promotion.dart';
import '../models/restaurant.dart';
import '../models/turn.dart';

class AppState extends ChangeNotifier {
  final _random = Random();

  String userName = MockData.userName;
  String userFullName = MockData.userFullName;
  String userEmail = MockData.userEmail;
  String location = MockData.location;

  List<Restaurant> restaurants = List.from(MockData.restaurants);
  List<Promotion> promotions = List.from(MockData.promotions);
  List<AppNotification> notifications = List.from(MockData.notifications);
  List<Turn> history = List.from(MockData.history);

  Turn? activeTurn;
  String? selectedCategory;
  String? selectedZone;
  String searchQuery = '';
  int bottomIndex = 0;

  static const zones = [
    'Todas',
    'Centro',
    'Montejo',
    'Altabrisa',
    'García Ginerés',
    'Norte',
    'Sur',
  ];

  Timer? _queueTimer;
  Timer? _restaurantTimer;

  AppState() {
    _startRestaurantFluctuations();
  }

  /// Demo auth: accepts any email/password and opens the app.
  void signIn({required String email, String? fullName}) {
    final trimmed = email.trim();
    userEmail = trimmed.isEmpty ? MockData.userEmail : trimmed;
    if (fullName != null && fullName.trim().isNotEmpty) {
      userFullName = fullName.trim();
      userName = userFullName.split(' ').first;
    } else {
      final local = userEmail.contains('@')
          ? userEmail.split('@').first
          : userEmail;
      userName = local.isEmpty
          ? MockData.userName
          : local[0].toUpperCase() + (local.length > 1 ? local.substring(1) : '');
      userFullName = userName;
    }
    notifyListeners();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  double _haversine(double lat, double lng) {
    const earth = 6371000.0;
    final p1 = MockData.userLatitude * 0.017453292519943295;
    final p2 = lat * 0.017453292519943295;
    final dp = (lat - MockData.userLatitude) * 0.017453292519943295;
    final dl = (lng - MockData.userLongitude) * 0.017453292519943295;
    final a = sin(dp / 2) * sin(dp / 2) +
        cos(p1) * cos(p2) * sin(dl / 2) * sin(dl / 2);
    return 2 * earth * asin(sqrt(a));
  }

  List<Restaurant> get nearbyRestaurants {
    var list = restaurants.toList();
    if (selectedCategory != null) {
      list = list.where((r) => r.category == selectedCategory).toList();
    }
    if (selectedZone != null && selectedZone != 'Todas') {
      final zone = selectedZone!.toLowerCase();
      list = list.where((r) {
        final loc = r.location.toLowerCase();
        if (zone == 'centro') {
          return loc.contains('centro') ||
              loc.contains('santa luc') ||
              loc.contains('santa ana') ||
              loc.contains('plaza grande') ||
              loc.contains('calle 47');
        }
        if (zone == 'montejo') {
          return loc.contains('montejo') || loc.contains('itzimná');
        }
        if (zone == 'norte') {
          return loc.contains('norte') ||
              loc.contains('francisco de montejo') ||
              loc.contains('plaza américas');
        }
        return loc.contains(zone);
      }).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where(
            (r) =>
                r.name.toLowerCase().contains(q) ||
                r.category.toLowerCase().contains(q) ||
                r.subcategory.toLowerCase().contains(q) ||
                r.location.toLowerCase().contains(q) ||
                r.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }
    list.sort((a, b) => _haversine(a.latitude, a.longitude)
        .compareTo(_haversine(b.latitude, b.longitude)));
    return list;
  }

  List<Restaurant> get shortestWait {
    final list = List<Restaurant>.from(restaurants)
      ..sort((a, b) => a.waitMinutes.compareTo(b.waitMinutes));
    return list.take(6).toList();
  }

  List<Restaurant> get topRated {
    final list = List<Restaurant>.from(restaurants)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(8).toList();
  }

  Restaurant? restaurantById(String id) {
    try {
      return restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void setBottomIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }

  void setCategory(String? category) {
    selectedCategory = selectedCategory == category ? null : category;
    notifyListeners();
  }

  void setZone(String? zone) {
    selectedZone = zone == 'Todas' ? null : zone;
    notifyListeners();
  }

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void markNotificationsRead() {
    notifications =
        notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    notifications = notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    notifyListeners();
  }

  Future<void> joinQueue({
    required Restaurant restaurant,
    required int partySize,
  }) async {
    final now = DateTime.now();
    final turnNumber = '#${(20 + _random.nextInt(30)).toString().padLeft(3, '0')}';
    final position = max(3, restaurant.peopleWaiting - _random.nextInt(3));

    activeTurn = Turn(
      id: 't_${now.millisecondsSinceEpoch}',
      restaurantId: restaurant.id,
      restaurantName: restaurant.name,
      restaurantImage: restaurant.imageUrl,
      restaurantAddress: restaurant.location,
      turnNumber: turnNumber,
      partySize: partySize,
      position: position,
      totalInQueue: restaurant.peopleWaiting + 1,
      estimatedMinutes: restaurant.waitMinutes,
      status: TurnStatus.waiting,
      joinedAt: now,
      lastUpdated: now,
      latitude: restaurant.latitude,
      longitude: restaurant.longitude,
    );

    _addNotification(
      title: 'Te uniste a la fila',
      body:
          'Tu turno es $turnNumber en ${restaurant.name}. Posición $position de ${restaurant.peopleWaiting + 1}.',
      type: NotificationType.turn,
      icon: 'confirmation_number',
    );

    _startTurnSimulation();
    notifyListeners();
  }

  void cancelActiveTurn() {
    if (activeTurn == null) return;
    final cancelled = activeTurn!.copyWith(
      status: TurnStatus.cancelled,
      lastUpdated: DateTime.now(),
      waitDurationMinutes:
          DateTime.now().difference(activeTurn!.joinedAt).inMinutes,
    );
    history = [cancelled, ...history];
    activeTurn = null;
    _queueTimer?.cancel();

    _addNotification(
      title: 'Turno cancelado',
      body: 'Cancelaste tu turno en ${cancelled.restaurantName}.',
      type: NotificationType.system,
      icon: 'cancel',
    );
    notifyListeners();
  }

  void simulateStatus(TurnStatus status) {
    if (activeTurn == null) return;
    activeTurn = activeTurn!.copyWith(
      status: status,
      lastUpdated: DateTime.now(),
      estimatedMinutes: status == TurnStatus.called ? 0 : activeTurn!.estimatedMinutes,
      position: status == TurnStatus.called ? 1 : activeTurn!.position,
    );

    if (status == TurnStatus.attended || status == TurnStatus.noShow) {
      final done = activeTurn!.copyWith(
        waitDurationMinutes:
            DateTime.now().difference(activeTurn!.joinedAt).inMinutes,
      );
      history = [done, ...history];
      activeTurn = null;
      _queueTimer?.cancel();
    }

    notifyListeners();
  }

  void _startTurnSimulation() {
    _queueTimer?.cancel();
    _queueTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (activeTurn == null || !activeTurn!.status.isActive) {
        _queueTimer?.cancel();
        return;
      }

      var turn = activeTurn!;
      var position = turn.position;
      var total = turn.totalInQueue;
      var minutes = turn.estimatedMinutes;
      var status = turn.status;

      // Advance queue occasionally
      if (position > 1 && _random.nextBool()) {
        position -= 1;
        total = max(position, total - 1);
        minutes = max(3, minutes - (3 + _random.nextInt(5)));
      } else {
        // Estimate can fluctuate slightly
        final delta = _random.nextInt(3) - 1;
        minutes = max(2, minutes + delta);
      }

      if (position <= 3 && status == TurnStatus.waiting) {
        status = TurnStatus.upcoming;
        _addNotification(
          title: '¡Prepárate!',
          body:
              'Tu turno está próximo. Tiempo estimado: $minutes minutos',
          type: NotificationType.turn,
          icon: 'notifications_active',
        );
      } else if (position == 1 && status == TurnStatus.upcoming) {
        status = TurnStatus.called;
        minutes = 0;
        _addNotification(
          title: '¡Ya puedes pasar!',
          body: 'El restaurante está listo para recibirte',
          type: NotificationType.turn,
          icon: 'check_circle',
        );
      } else if (position < turn.position) {
        _addNotification(
          title: '¡Tu turno está avanzando!',
          body: 'Ahora estás en la posición $position de $total',
          type: NotificationType.turn,
          icon: 'trending_up',
        );
      }

      activeTurn = turn.copyWith(
        position: position,
        totalInQueue: total,
        estimatedMinutes: minutes,
        status: status,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();
    });
  }

  void _startRestaurantFluctuations() {
    _restaurantTimer?.cancel();
    _restaurantTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      restaurants = restaurants.map((r) {
        if (r.queueStatus == QueueStatus.closed) return r;
        final waitDelta = _random.nextInt(5) - 2;
        final peopleDelta = _random.nextInt(3) - 1;
        final wait = max(5, r.waitMinutes + waitDelta);
        final people = max(1, r.peopleWaiting + peopleDelta);
        final status = wait > 40 ? QueueStatus.busy : QueueStatus.open;
        return r.copyWith(
          waitMinutes: wait,
          peopleWaiting: people,
          queueStatus: status,
        );
      }).toList();
      notifyListeners();
    });
  }

  void _addNotification({
    required String title,
    required String body,
    required NotificationType type,
    required String icon,
  }) {
    notifications = [
      AppNotification(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        time: DateTime.now(),
        type: type,
        isRead: false,
        icon: icon,
      ),
      ...notifications,
    ];
  }

  @override
  void dispose() {
    _queueTimer?.cancel();
    _restaurantTimer?.cancel();
    super.dispose();
  }
}
