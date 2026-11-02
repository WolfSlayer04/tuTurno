import '../models/app_notification.dart';
import '../models/promotion.dart';
import '../models/restaurant.dart';
import '../models/turn.dart';
import 'restaurants_catalog.dart';

class MockData {
  static const userName = 'Alejandro';
  static const userFullName = 'Alejandro Arellano';
  static const userEmail = 'alejandro.arellano@email.com';
  static const location = 'Mérida, Yucatán';

  /// Punto demo del usuario (Plaza Grande / Centro Histórico).
  static const double userLatitude = 20.9671;
  static const double userLongitude = -89.6237;

  static const categories = [
    ('Hamburguesas', 'lunch_dining'),
    ('Mexicana', 'restaurant'),
    ('Sushi', 'set_meal'),
    ('Mariscos', 'rice_bowl'),
    ('Cafeterías', 'local_cafe'),
    ('Pizza', 'local_pizza'),
    ('Internacional', 'public'),
  ];

  static List<Restaurant> get restaurants =>
      List<Restaurant>.from(RestaurantsCatalog.all);

  static List<Promotion> promotions = [
    Promotion(
      id: 'p1',
      restaurantId: 'r1',
      restaurantName: 'La Chaya Maya',
      title: '10% en bebidas',
      description:
          'Aprovecha 10% de descuento en bebidas al unirte a la fila.',
      discount: '10%',
      validity: 'Vigente hasta 30 nov',
      distance: '320 m',
      imageUrl:
          'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&q=80',
      category: 'Mexicana',
    ),
    Promotion(
      id: 'p2',
      restaurantId: 'r12',
      restaurantName: 'Flamante Burgers',
      title: '2x1 en postres',
      description: 'Pide un postre y lleva el segundo gratis en tu visita.',
      discount: '2x1',
      validity: 'Vigente este fin de semana',
      distance: '680 m',
      imageUrl:
          'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800&q=80',
      category: 'Hamburguesas',
    ),
    Promotion(
      id: 'p3',
      restaurantId: 'r9',
      restaurantName: 'Yakuza Sushi Centro',
      title: 'Combo especial para dos',
      description: 'Rolls + bebidas para compartir a precio especial.',
      discount: 'Combo',
      validity: 'Vigente hasta 15 dic',
      distance: '720 m',
      imageUrl:
          'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=800&q=80',
      category: 'Sushi',
    ),
    Promotion(
      id: 'p4',
      restaurantId: 'r7',
      restaurantName: 'Pizzeria Oliva',
      title: 'Pizza mediana + refresco',
      description: 'Combo especial al unirte a la fila virtual.',
      discount: 'Combo',
      validity: 'Vigente lunes a jueves',
      distance: '780 m',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
      category: 'Pizza',
    ),
    Promotion(
      id: 'p5',
      restaurantId: 'r23',
      restaurantName: 'Delina Rooftop',
      title: '2x1 en cócteles de autor',
      description: 'Válido de 17:00 a 19:00 mientras esperas tu mesa.',
      discount: '2x1',
      validity: 'Vigente este mes',
      distance: '2.2 km',
      imageUrl:
          'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&q=80',
      category: 'Internacional',
    ),
    Promotion(
      id: 'p6',
      restaurantId: 'r35',
      restaurantName: 'Los Trompos Altabrisa',
      title: 'Taco extra gratis',
      description: 'Al unirte a la fila recibe un taco al pastor adicional.',
      discount: '+1',
      validity: 'Vigente viernes y sábado',
      distance: '3.6 km',
      imageUrl:
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&q=80',
      category: 'Mexicana',
    ),
  ];

  static List<Turn> history = [
    Turn(
      id: 'h1',
      restaurantId: 'r12',
      restaurantName: 'Flamante Burgers',
      restaurantImage:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80',
      restaurantAddress: 'Calle 47, Mérida',
      turnNumber: '#018',
      partySize: 2,
      position: 1,
      totalInQueue: 6,
      estimatedMinutes: 0,
      status: TurnStatus.attended,
      joinedAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      waitDurationMinutes: 18,
      latitude: 20.9725,
      longitude: -89.6240,
    ),
    Turn(
      id: 'h2',
      restaurantId: 'r9',
      restaurantName: 'Yakuza Sushi Centro',
      restaurantImage:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&q=80',
      restaurantAddress: 'Calle 47, Mérida',
      turnNumber: '#031',
      partySize: 3,
      position: 0,
      totalInQueue: 10,
      estimatedMinutes: 0,
      status: TurnStatus.cancelled,
      joinedAt: DateTime.now().subtract(const Duration(days: 7)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
      waitDurationMinutes: 12,
      latitude: 20.9728,
      longitude: -89.6224,
    ),
    Turn(
      id: 'h3',
      restaurantId: 'r1',
      restaurantName: 'La Chaya Maya',
      restaurantImage:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
      restaurantAddress: 'Centro Histórico, Mérida',
      turnNumber: '#009',
      partySize: 4,
      position: 0,
      totalInQueue: 15,
      estimatedMinutes: 0,
      status: TurnStatus.noShow,
      joinedAt: DateTime.now().subtract(const Duration(days: 12)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 12)),
      waitDurationMinutes: 40,
      latitude: 20.9698,
      longitude: -89.6228,
    ),
  ];

  static List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: '¡Tu turno está avanzando!',
      body: 'Ahora estás en la posición 5 de la fila',
      time: DateTime.now().subtract(const Duration(minutes: 8)),
      type: NotificationType.turn,
      isRead: false,
      icon: 'trending_up',
    ),
    AppNotification(
      id: 'n2',
      title: '¡Prepárate!',
      body: 'Tu turno está próximo. Tiempo estimado: 10 minutos',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
      type: NotificationType.turn,
      isRead: false,
      icon: 'notifications_active',
    ),
    AppNotification(
      id: 'n3',
      title: '¡Ya puedes pasar!',
      body: 'El restaurante está listo para recibirte',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.turn,
      isRead: true,
      icon: 'check_circle',
    ),
    AppNotification(
      id: 'n4',
      title: 'Promoción especial',
      body: 'Disfruta de un 10% de descuento en bebidas en La Chaya Maya',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.promotion,
      isRead: true,
      icon: 'local_offer',
    ),
  ];
}
