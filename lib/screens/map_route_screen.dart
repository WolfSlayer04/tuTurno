import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/mock_data.dart';
import '../services/route_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../widgets/primary_button.dart';

class MapRouteScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantAddress;
  final double destinationLat;
  final double destinationLng;
  final String? imageUrl;

  const MapRouteScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.destinationLat,
    required this.destinationLng,
    this.imageUrl,
  });

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  final _mapController = MapController();
  late final LatLng _origin;
  late final LatLng _destination;

  RouteResult? _route;
  bool _loading = true;
  String? _error;
  bool _showSteps = false;

  @override
  void initState() {
    super.initState();
    _origin = const LatLng(MockData.userLatitude, MockData.userLongitude);
    _destination = LatLng(widget.destinationLat, widget.destinationLng);
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final route = await RouteService.fetchRoute(
        from: _origin,
        to: _destination,
      );
      if (!mounted) return;
      setState(() {
        _route = route;
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudo cargar la ruta';
      });
    }
  }

  void _fitBounds() {
    final points = _route?.points ?? [_origin, _destination];
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(48, 120, 48, 280),
      ),
    );
  }

  Future<void> _openExternalMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${_origin.latitude},${_origin.longitude}'
      '&destination=${_destination.latitude},${_destination.longitude}'
      '&travelmode=walking',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (_origin.latitude + _destination.latitude) / 2,
                (_origin.longitude + _destination.longitude) / 2,
              ),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tuturno.tu_turno',
              ),
              if (route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route.points,
                      color: AppColors.turquoise.withValues(alpha: 0.35),
                      strokeWidth: 10,
                    ),
                    Polyline(
                      points: route.points,
                      color: AppColors.turquoise,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _origin,
                    width: 54,
                    height: 54,
                    child: _MapPin(
                      color: AppColors.primary,
                      icon: Icons.person_pin_circle_rounded,
                      label: 'Tú',
                    ),
                  ),
                  Marker(
                    point: _destination,
                    width: 54,
                    height: 54,
                    child: _MapPin(
                      color: AppColors.turquoise,
                      icon: Icons.restaurant_rounded,
                      label: 'Meta',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  _RoundIconButton(
                    icon: Icons.my_location_rounded,
                    onTap: _fitBounds,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomSheet(
              restaurantName: widget.restaurantName,
              address: widget.restaurantAddress,
              imageUrl: widget.imageUrl,
              loading: _loading,
              error: _error,
              route: route,
              showSteps: _showSteps,
              onToggleSteps: () => setState(() => _showSteps = !_showSteps),
              onRetry: _loadRoute,
              onOpenExternal: _openExternalMaps,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _MapPin({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft,
            border: Border.all(color: AppColors.white, width: 3),
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.soft,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final String restaurantName;
  final String address;
  final String? imageUrl;
  final bool loading;
  final String? error;
  final RouteResult? route;
  final bool showSteps;
  final VoidCallback onToggleSteps;
  final VoidCallback onRetry;
  final VoidCallback onOpenExternal;

  const _BottomSheet({
    required this.restaurantName,
    required this.address,
    required this.imageUrl,
    required this.loading,
    required this.error,
    required this.route,
    required this.showSteps,
    required this.onToggleSteps,
    required this.onRetry,
    required this.onOpenExternal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.all(14),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (showSteps ? 0.58 : 0.36),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.sheet,
        boxShadow: AppShadows.soft,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: AppColors.mint,
                          child: const Icon(
                            Icons.restaurant,
                            color: AppColors.turquoise,
                          ),
                        ),
                      ),
                    ),
                  if (imageUrl != null) const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: CircularProgressIndicator(color: AppColors.turquoise),
                )
              else if (error != null)
                Column(
                  children: [
                    Text(error!, style: GoogleFonts.inter(color: AppColors.danger)),
                    TextButton(onPressed: onRetry, child: const Text('Reintentar')),
                  ],
                )
              else if (route != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: _StatPill(
                        icon: Icons.directions_walk_rounded,
                        label: 'Distancia',
                        value: route!.distanceLabel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatPill(
                        icon: Icons.schedule_rounded,
                        label: 'A pie',
                        value: route!.durationLabel,
                      ),
                    ),
                  ],
                ),
                if (showSteps) ...[
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: route!.steps.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final step = route!.steps[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.mint,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.turquoise,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.instruction,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.darkGray,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (step.distanceMeters > 0)
                                      Text(
                                        step.distanceLabel,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: showSteps ? 'Ocultar ruta' : 'Ver ruta completa',
                        onPressed: onToggleSteps,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Abrir Maps',
                        icon: Icons.map_rounded,
                        onPressed: onOpenExternal,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.turquoise, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
