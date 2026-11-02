import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/turn.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../widgets/primary_button.dart';
import '../widgets/queue_progress_bar.dart';
import '../widgets/queue_status_chip.dart';
import 'map_route_screen.dart';

class MyTurnScreen extends StatelessWidget {
  const MyTurnScreen({super.key});

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _cancelTurn(BuildContext context, AppState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          '¿Cancelar turno?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Perderás tu lugar en la fila. Esta acción no se puede deshacer.',
          style: GoogleFonts.inter(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Mantener turno'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sí, cancelar',
              style: GoogleFonts.inter(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      state.cancelActiveTurn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final turn = state.activeTurn;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: turn == null
            ? _EmptyTurn(onExplore: () => state.setBottomIndex(0))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mi turno',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              TurnStatusChip(status: turn.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.28),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        turn.restaurantImage,
                                        width: 52,
                                        height: 52,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 52,
                                          height: 52,
                                          color: AppColors.turquoise,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            turn.restaurantName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          Text(
                                            '${turn.partySize} personas',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: AppColors.white
                                                  .withValues(alpha: 0.75),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  turn.turnNumber,
                                  style: GoogleFonts.poppins(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Número de turno',
                                  style: GoogleFonts.inter(
                                    color: AppColors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _StatBlock(
                                        label: 'Posición',
                                        value:
                                            '${turn.position} de ${turn.totalInQueue}',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _StatBlock(
                                        label: 'Estimado',
                                        value: '${turn.estimatedMinutes} min',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                QueueProgressBar(
                                  progress: turn.progress,
                                  label: 'Avance de la fila',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.mint,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_walk_rounded,
                                  color: AppColors.turquoise,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '¡Todo va avanzando! Puedes aprovechar este tiempo para dar una vuelta',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            '¿Qué puedes hacer mientras esperas?',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...[
                            ('Dar una vuelta por la zona', Icons.park_outlined),
                            ('Revisar promociones cercanas', Icons.local_offer_outlined),
                            ('Preparar tu pedido ideal', Icons.restaurant_menu_outlined),
                          ].map(
                            (item) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Icon(item.$2, color: AppColors.turquoise),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.$1,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (state.promotions.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Promoción cerca',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.promotions.first.title,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    state.promotions.first.restaurantName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: AppRadii.card,
                              boxShadow: AppShadows.soft,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dirección',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  turn.restaurantAddress,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                PrimaryButton(
                                  label: 'Cómo llegar',
                                  icon: Icons.directions_rounded,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => MapRouteScreen(
                                          restaurantName: turn.restaurantName,
                                          restaurantAddress:
                                              turn.restaurantAddress,
                                          destinationLat: turn.latitude,
                                          destinationLng: turn.longitude,
                                          imageUrl: turn.restaurantImage,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Incorporación: ${_formatTime(turn.joinedAt)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Última actualización: ${_formatTime(turn.lastUpdated)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Demo controls for turn states
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _DemoChip(
                                label: 'Próximo',
                                onTap: () =>
                                    state.simulateStatus(TurnStatus.upcoming),
                              ),
                              _DemoChip(
                                label: 'Llamado',
                                onTap: () =>
                                    state.simulateStatus(TurnStatus.called),
                              ),
                              _DemoChip(
                                label: 'Atendido',
                                onTap: () =>
                                    state.simulateStatus(TurnStatus.attended),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => _cancelTurn(context, state),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: Color(0xFFFFD4CF)),
                              minimumSize: const Size(double.infinity, 52),
                            ),
                            child: const Text('Cancelar turno'),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EmptyTurn extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyTurn({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Mi turno',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              size: 44,
              color: AppColors.turquoise,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No tienes un turno activo',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explora restaurantes cerca de ti y únete a una fila virtual en segundos.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Explorar restaurantes', onPressed: onExplore),
          const Spacer(),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DemoChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.border),
    );
  }
}
