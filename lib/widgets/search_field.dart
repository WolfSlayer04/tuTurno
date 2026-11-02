import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    this.hint = 'Busca restaurantes o comida',
    this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadii.input,
              boxShadow: AppShadows.soft,
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.muted),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 10),
          Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.soft,
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
