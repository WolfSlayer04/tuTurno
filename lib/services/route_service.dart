import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteStep {
  final String instruction;
  final String roadName;
  final double distanceMeters;
  final double durationSeconds;

  const RouteStep({
    required this.instruction,
    required this.roadName,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.round()} m';
  }
}

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
  final List<RouteStep> steps;

  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.steps,
  });

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.round()} m';
  }

  String get durationLabel {
    final minutes = (durationSeconds / 60).round().clamp(1, 999);
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}min';
  }
}

class RouteService {
  /// Walking route via public OSRM. Falls back to a straight path if offline.
  static Future<RouteResult> fetchRoute({
    required LatLng from,
    required LatLng to,
    String profile = 'foot',
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/$profile/'
      '${from.longitude},${from.latitude};'
      '${to.longitude},${to.latitude}'
      '?overview=full&geometries=geojson&steps=true',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return _fallback(from, to);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return _fallback(from, to);

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coords = geometry['coordinates'] as List<dynamic>;

      final points = coords
          .map((c) {
            final pair = c as List<dynamic>;
            return LatLng(
              (pair[1] as num).toDouble(),
              (pair[0] as num).toDouble(),
            );
          })
          .toList();

      final steps = <RouteStep>[];
      final legs = route['legs'] as List<dynamic>? ?? [];
      for (final leg in legs) {
        final legMap = leg as Map<String, dynamic>;
        final legSteps = legMap['steps'] as List<dynamic>? ?? [];
        for (final step in legSteps) {
          final s = step as Map<String, dynamic>;
          final maneuver = s['maneuver'] as Map<String, dynamic>? ?? {};
          final type = (maneuver['type'] as String?) ?? 'continue';
          final modifier = maneuver['modifier'] as String?;
          final name = (s['name'] as String?)?.trim() ?? '';
          final dist = (s['distance'] as num?)?.toDouble() ?? 0;
          final dur = (s['duration'] as num?)?.toDouble() ?? 0;

          if (type == 'arrive') {
            steps.add(
              RouteStep(
                instruction: 'Has llegado a tu destino',
                roadName: name,
                distanceMeters: dist,
                durationSeconds: dur,
              ),
            );
            continue;
          }

          steps.add(
            RouteStep(
              instruction: _instructionEs(type, modifier, name),
              roadName: name,
              distanceMeters: dist,
              durationSeconds: dur,
            ),
          );
        }
      }

      return RouteResult(
        points: points,
        distanceMeters: (route['distance'] as num?)?.toDouble() ?? 0,
        durationSeconds: (route['duration'] as num?)?.toDouble() ?? 0,
        steps: steps,
      );
    } catch (_) {
      return _fallback(from, to);
    }
  }

  static RouteResult _fallback(LatLng from, LatLng to) {
    const distance = Distance();
    final meters = distance.as(LengthUnit.Meter, from, to);
    return RouteResult(
      points: [from, to],
      distanceMeters: meters,
      durationSeconds: meters / 1.3,
      steps: [
        RouteStep(
          instruction: 'Dirígete hacia el restaurante',
          roadName: '',
          distanceMeters: meters,
          durationSeconds: meters / 1.3,
        ),
        const RouteStep(
          instruction: 'Has llegado a tu destino',
          roadName: '',
          distanceMeters: 0,
          durationSeconds: 0,
        ),
      ],
    );
  }

  static String _instructionEs(String type, String? modifier, String name) {
    final via = name.isEmpty ? '' : ' por $name';
    switch (type) {
      case 'depart':
        return name.isEmpty ? 'Sal hacia tu destino' : 'Sal por $name';
      case 'turn':
        return 'Gira ${_modifierEs(modifier)}$via';
      case 'new name':
        return name.isEmpty ? 'Continúa recto' : 'Continúa por $name';
      case 'continue':
        return name.isEmpty ? 'Sigue adelante' : 'Sigue por $name';
      case 'merge':
        return 'Incorpórate$via';
      case 'on ramp':
        return 'Toma la rampa$via';
      case 'off ramp':
        return 'Sal de la vía$via';
      case 'fork':
        return 'Mantente ${_modifierEs(modifier)}$via';
      case 'end of road':
        return 'Al final de la calle, gira ${_modifierEs(modifier)}$via';
      case 'roundabout':
      case 'rotary':
        return 'Entra a la glorieta$via';
      case 'notification':
        return name.isEmpty ? 'Continúa' : 'Continúa por $name';
      default:
        return name.isEmpty ? 'Continúa' : 'Continúa por $name';
    }
  }

  static String _modifierEs(String? modifier) {
    switch (modifier) {
      case 'left':
        return 'a la izquierda';
      case 'right':
        return 'a la derecha';
      case 'slight left':
        return 'leve a la izquierda';
      case 'slight right':
        return 'leve a la derecha';
      case 'sharp left':
        return 'cerrado a la izquierda';
      case 'sharp right':
        return 'cerrado a la derecha';
      case 'straight':
        return 'recto';
      case 'uturn':
        return 'en U';
      default:
        return 'adelante';
    }
  }
}
