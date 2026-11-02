import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/turn.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/queue_status_chip.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'Todos';

  String _formatDate(DateTime dt) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filters = ['Todos', 'Atendidos', 'Cancelados'];

    final items = state.history.where((t) {
      if (_filter == 'Atendidos') return t.status == TurnStatus.attended;
      if (_filter == 'Cancelados') {
        return t.status == TurnStatus.cancelled ||
            t.status == TurnStatus.noShow;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Historial de turnos'),
        backgroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: filters.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppColors.primary,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.white : AppColors.darkGray,
                    ),
                    backgroundColor: AppColors.lightGray,
                    side: BorderSide.none,
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? _EmptyHistory()
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final turn = items[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                turn.restaurantImage,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 64,
                                  height: 64,
                                  color: AppColors.mint,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          turn.restaurantName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      TurnStatusChip(status: turn.status),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatDate(turn.joinedAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Turno ${turn.turnNumber} · ${turn.partySize} personas',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                  if (turn.waitDurationMinutes != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Espera aprox. ${turn.waitDurationMinutes} min',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 40,
                color: AppColors.turquoise,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Aún no tienes historial',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando te unas a filas virtuales, aquí verás tus visitas anteriores.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
