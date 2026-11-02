class Promotion {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String title;
  final String description;
  final String discount;
  final String validity;
  final String distance;
  final String imageUrl;
  final String category;

  const Promotion({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.title,
    required this.description,
    required this.discount,
    required this.validity,
    required this.distance,
    required this.imageUrl,
    required this.category,
  });
}
