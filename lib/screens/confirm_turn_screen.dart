import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/party_size_selector.dart';
import '../widgets/primary_button.dart';
import '../widgets/wait_time_badge.dart';
import 'main_shell.dart';

class ConfirmTurnScreen extends StatefulWidget {
  final String restaurantId;

  const ConfirmTurnScreen({super.key, required this.restaurantId});

  @override
  State<ConfirmTurnScreen> createState() => _ConfirmTurnScreenState();
}

class _ConfirmTurnScreenState extends State<ConfirmTurnScreen> {
  int _partySize = 2;
  bool _loading = false;

  Future<void> _confirm() async {
    final state = context.read<AppState>();
    final restaurant = state.restaurantById(widget.restaurantId);
    if (restaurant == null) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    await state.joinQueue(restaurant: restaurant, partySize: _partySize);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          '¡Listo!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Ya estás en la fila de ${restaurant.name}. Te avisaremos cuando tu turno esté próximo.',
          style: GoogleFonts.inter(color: AppColors.muted, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              state.setBottomIndex(2);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainShell()),
                (_) => false,
              );
            },
            child: const Text('Ver mi turno'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant =
        context.watch<AppState>().restaurantById(widget.restaurantId);

    if (restaurant == null) {
      return const Scaffold(body: Center(child: Text('Restaurante no encontrado')));
    }

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Confirma tu turno'),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                restaurant.imageUrl,
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
                                  Text(
                                    restaurant.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    restaurant.location,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  WaitTimeBadge(minutes: restaurant.waitMinutes),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PartySizeSelector(
                        value: _partySize,
                        onChanged: (v) => setState(() => _partySize = v),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tiempo estimado',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${restaurant.waitMinutes} minutos',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _Tip(
                              icon: Icons.notifications_active_outlined,
                              text:
                                  'Recibirás una notificación cuando tu turno esté próximo',
                            ),
                            const SizedBox(height: 10),
                            _Tip(
                              icon: Icons.info_outline_rounded,
                              text:
                                  'El tiempo de espera es aproximado y puede cambiar',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Confirmar mi turno',
                loading: _loading,
                onPressed: _confirm,
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Cancelar',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.turquoise),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.muted,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
