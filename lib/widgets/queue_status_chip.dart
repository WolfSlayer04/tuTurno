import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/restaurant.dart';
import '../models/turn.dart';
import '../theme/app_colors.dart';

class QueueStatusChip extends StatelessWidget {
  final QueueStatus status;

  const QueueStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;

    switch (status) {
      case QueueStatus.open:
        bg = AppColors.mint;
        fg = AppColors.turquoise;
        label = 'Fila abierta';
      case QueueStatus.busy:
        bg = const Color(0xFFFFF3E4);
        fg = AppColors.alert;
        label = 'Alta demanda';
      case QueueStatus.closed:
        bg = AppColors.lightGray;
        fg = AppColors.muted;
        label = 'Fila cerrada';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class TurnStatusChip extends StatelessWidget {
  final TurnStatus status;

  const TurnStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;

    switch (status) {
      case TurnStatus.waiting:
        bg = AppColors.mint;
        fg = AppColors.turquoise;
      case TurnStatus.upcoming:
        bg = const Color(0xFFFFF3E4);
        fg = AppColors.alert;
      case TurnStatus.called:
        bg = AppColors.primary;
        fg = AppColors.white;
      case TurnStatus.attended:
        bg = AppColors.mint;
        fg = AppColors.turquoise;
      case TurnStatus.cancelled:
        bg = AppColors.lightGray;
        fg = AppColors.muted;
      case TurnStatus.noShow:
        bg = const Color(0xFFFFE8E5);
        fg = AppColors.danger;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        status.label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
