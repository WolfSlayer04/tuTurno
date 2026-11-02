import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/restaurant.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../widgets/queue_status_chip.dart';
import '../widgets/search_field.dart';
import '../widgets/wait_time_badge.dart';
import 'map_route_screen.dart';
import 'restaurant_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _mapController = MapController();
  String? _selectedId;
  bool _listExpanded = false;

  static const _user = LatLng(MockData.userLatitude, MockData.userLongitude);

  void _fitToRestaurants(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) {
      _mapController.move(_user, 13);
      return;
    }
    final points = [
      _user,
      ...restaurants.map((r) => LatLng(r.latitude, r.longitude)),
    ];
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.fromLTRB(
          48,
          180,
          48,
          _listExpanded ? 340 : 220,
        ),
      ),
    );
  }

  void _selectRestaurant(Restaurant restaurant, {bool moveCamera = true}) {
    setState(() => _selectedId = restaurant.id);
    if (moveCamera) {
      _mapController.move(
        LatLng(restaurant.latitude, restaurant.longitude),
        15.2,
      );
    }
  }

  Color _markerColor(Restaurant r) {
    if (r.waitMinutes <= 15) return AppColors.turquoise;
    if (r.waitMinutes <= 30) return AppColors.alert;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final restaurants = state.nearbyRestaurants;
    final activeZone = state.selectedZone ?? 'Todas';
    Restaurant? selected;
    if (restaurants.isNotEmpty) {
      selected = restaurants.cast<Restaurant?>().firstWhere(
            (r) => r?.id == _selectedId,
            orElse: () => restaurants.first,
          );
    }

    // Keep selection valid when filters change
    if (_selectedId != null &&
        restaurants.every((r) => r.id != _selectedId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _selectedId = restaurants.isEmpty ? null : restaurants.first.id);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _user,
              initialZoom: 13.2,
              onMapReady: () => _fitToRestaurants(restaurants),
              onTap: (_, __) => setState(() => _selectedId = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tuturno.tu_turno',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _user,
                    width: 52,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: AppShadows.soft,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  ...restaurants.map((r) {
                    final isSelected = r.id == (_selectedId ?? selected?.id);
                    final color = _markerColor(r);
                    return Marker(
                      point: LatLng(r.latitude, r.longitude),
                      width: isSelected ? 56 : 44,
                      height: isSelected ? 56 : 44,
                      child: GestureDetector(
                        onTap: () => _selectRestaurant(r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: isSelected ? 3.5 : 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: isSelected ? 16 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: AppColors.white,
                            size: isSelected ? 22 : 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Top controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppShadows.soft,
                    ),
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
                                    'Explorar Mérida',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    '${restaurants.length} restaurantes en el mapa',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _MapAction(
                              icon: Icons.my_location_rounded,
                              onTap: () => _fitToRestaurants(restaurants),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SearchField(onChanged: state.setSearch),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: AppState.zones.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final zone = AppState.zones[index];
                              final selectedZone = activeZone == zone;
                              return ChoiceChip(
                                label: Text(zone),
                                selected: selectedZone,
                                onSelected: (_) {
                                  state.setZone(zone);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    _fitToRestaurants(
                                      context.read<AppState>().nearbyRestaurants,
                                    );
                                  });
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selectedZone
                                      ? AppColors.white
                                      : AppColors.darkGray,
                                ),
                                backgroundColor: AppColors.lightGray,
                                showCheckmark: false,
                                side: BorderSide.none,
                                visualDensity: VisualDensity.compact,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _LegendDot(color: AppColors.turquoise, label: '≤15 min'),
                            const SizedBox(width: 10),
                            _LegendDot(color: AppColors.alert, label: '≤30 min'),
                            const SizedBox(width: 10),
                            _LegendDot(color: AppColors.danger, label: '>30 min'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setState(() => _listExpanded = !_listExpanded);
                              },
                              child: Text(
                                _listExpanded ? 'Ocultar lista' : 'Ver lista',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom selected card + optional list
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_listExpanded)
                    SizedBox(
                      height: 168,
                      child: restaurants.isEmpty
                          ? Center(
                              child: Text(
                                'Sin resultados',
                                style: GoogleFonts.inter(color: AppColors.muted),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurants.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final r = restaurants[index];
                                final active = r.id == (selected?.id);
                                return GestureDetector(
                                  onTap: () => _selectRestaurant(r),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 220,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: active
                                            ? AppColors.turquoise
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: AppShadows.soft,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: Image.network(
                                            r.imageUrl,
                                            height: 72,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                              height: 72,
                                              color: AppColors.mint,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
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
                  if (selected case final Restaurant current)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _SelectedRestaurantCard(
                        restaurant: current,
                        onOpen: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                restaurantId: current.id,
                              ),
                            ),
                          );
                        },
                        onRoute: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MapRouteScreen(
                                restaurantName: current.name,
                                restaurantAddress: current.location,
                                destinationLat: current.latitude,
                                destinationLng: current.longitude,
                                imageUrl: current.imageUrl,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (restaurants.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: AppRadii.card,
                          boxShadow: AppShadows.soft,
                        ),
                        child: Text(
                          'No hay restaurantes con estos filtros',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.muted),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mint,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: AppColors.turquoise),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _SelectedRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onOpen;
  final VoidCallback onRoute;

  const _SelectedRestaurantCard({
    required this.restaurant,
    required this.onOpen,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  restaurant.imageUrl,
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 78,
                    height: 78,
                    color: AppColors.mint,
                    child: const Icon(Icons.restaurant, color: AppColors.turquoise),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${restaurant.category} · ${restaurant.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        QueueStatusChip(status: restaurant.queueStatus),
                        const SizedBox(width: 8),
                        WaitTimeBadge(minutes: restaurant.waitMinutes),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  _MiniAction(
                    icon: Icons.directions_rounded,
                    onTap: onRoute,
                  ),
                  const SizedBox(height: 8),
                  _MiniAction(
                    icon: Icons.arrow_forward_rounded,
                    onTap: onOpen,
                    filled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _MiniAction({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.turquoise : AppColors.mint,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 18,
            color: filled ? AppColors.white : AppColors.turquoise,
          ),
        ),
      ),
    );
  }
}
