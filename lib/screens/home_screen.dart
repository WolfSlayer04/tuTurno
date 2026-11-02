import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_field.dart';
import '../widgets/wait_time_badge.dart';
import 'notifications_screen.dart';
import 'promotions_screen.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _categoryIcon(String name) {
    switch (name) {
      case 'lunch_dining':
        return Icons.lunch_dining_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'set_meal':
        return Icons.set_meal_rounded;
      case 'rice_bowl':
        return Icons.rice_bowl_rounded;
      case 'local_cafe':
        return Icons.local_cafe_rounded;
      case 'local_pizza':
        return Icons.local_pizza_rounded;
      case 'public':
        return Icons.travel_explore_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Hola, ${state.userName}!',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¿Dónde quieres comer hoy?',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _IconBubble(
                          icon: Icons.notifications_none_rounded,
                          badge: state.unreadCount,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: AppColors.turquoise,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.location,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PromotionsScreen(),
                              ),
                            );
                          },
                          child: const Text('Promociones'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SearchField(
                      onChanged: state.setSearch,
                      onFilterTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filtros: distancia, tiempo y categoría'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = MockData.categories[index];
                          final selected = state.selectedCategory == cat.$1;
                          return GestureDetector(
                            onTap: () => state.setCategory(cat.$1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 86,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primary : AppColors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.22),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.05),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _categoryIcon(cat.$2),
                                    color: selected
                                        ? AppColors.white
                                        : AppColors.turquoise,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cat.$1,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? AppColors.white
                                          : AppColors.darkGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (state.activeTurn != null) ...[
                      const SizedBox(height: 18),
                      _ActiveTurnBanner(
                        onTap: () => state.setBottomIndex(2),
                        restaurant: state.activeTurn!.restaurantName,
                        position:
                            '${state.activeTurn!.position} de ${state.activeTurn!.totalInQueue}',
                        minutes: state.activeTurn!.estimatedMinutes,
                      ),
                    ],
                    const SizedBox(height: 22),
                    _SectionTitle(
                      title: 'Cerca de ti',
                      action: 'Ver todos',
                      onAction: () => state.setBottomIndex(1),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverList.separated(
                itemCount: state.nearbyRestaurants.take(8).length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final restaurant = state.nearbyRestaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailScreen(restaurantId: restaurant.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: _SectionTitle(title: 'Menor tiempo de espera'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 168,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.shortestWait.take(6).length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final r = state.shortestWait[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(restaurantId: r.id),
                          ),
                        );
                      },
                      child: Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                r.imageUrl,
                                height: 78,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 78,
                                  color: AppColors.mint,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              r.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            WaitTimeBadge(minutes: r.waitMinutes),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionTitle({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final int badge;
  final VoidCallback onTap;

  const _IconBubble({
    required this.icon,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
                        Material(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(icon, color: AppColors.primary),
                            ),
                          ),
                        ),
        if (badge > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.alert,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badge',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActiveTurnBanner extends StatelessWidget {
  final VoidCallback onTap;
  final String restaurant;
  final String position;
  final int minutes;

  const _ActiveTurnBanner({
    required this.onTap,
    required this.restaurant,
    required this.position,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.turquoise,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fila activa · $restaurant',
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Posición $position · ~$minutes min',
                      style: GoogleFonts.inter(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
