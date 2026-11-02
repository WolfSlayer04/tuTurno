import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppRadii {
  static const double sm = 14;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 28;
  static const double pill = 40;

  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get button => BorderRadius.circular(md);
  static BorderRadius get chip => BorderRadius.circular(pill);
  static BorderRadius get input => BorderRadius.circular(md);
  static BorderRadius get sheet => BorderRadius.circular(xl);
}

class AppShadows {
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: AppColors.turquoise.withValues(alpha: 0.18),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];
}
