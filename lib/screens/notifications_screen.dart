import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/app_notification.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filters = ['Todas', 'Turnos', 'Promociones'];

    final items = state.notifications.where((n) {
      if (_filter == 'Turnos') return n.type == NotificationType.turn;
      if (_filter == 'Promociones') return n.type == NotificationType.promotion;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: AppColors.white,
        actions: [
          TextButton(
            onPressed: state.markNotificationsRead,
            child: const Text('Marcar leídas'),
          ),
        ],
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
                ? Center(
                    child: Text(
                      'No hay notificaciones',
                      style: GoogleFonts.inter(color: AppColors.muted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return NotificationCard(
                        notification: item,
                        onTap: () => state.markNotificationRead(item.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
