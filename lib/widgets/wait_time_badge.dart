import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class WaitTimeBadge extends StatelessWidget {
  final int minutes;
  final bool large;

  const WaitTimeBadge({super.key, required this.minutes, this.large = false});

  Color get _bg {
    if (minutes <= 15) return AppColors.mint;
    if (minutes <= 30) return const Color(0xFFFFF3E4);
    return const Color(0xFFFFE8E5);
  }

  Color get _fg {
    if (minutes <= 15) return AppColors.turquoise;
    if (minutes <= 30) return AppColors.alert;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 11,
        vertical: large ? 8 : 7,
      ),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: large ? 18 : 14, color: _fg),
          const SizedBox(width: 4),
          Text(
            '$minutes min',
            style: GoogleFonts.inter(
              fontSize: large ? 14 : 12,
              fontWeight: FontWeight.w700,
              color: _fg,
            ),
          ),
        ],
      ),
    );
  }
}
