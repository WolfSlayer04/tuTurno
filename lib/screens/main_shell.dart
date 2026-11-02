import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/turn.dart';
import '../state/app_state.dart';
import '../widgets/bottom_nav.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'my_turn_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const MyTurnScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: state.bottomIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: state.bottomIndex,
        hasActiveTurn: state.activeTurn?.status.isActive ?? false,
        onTap: state.setBottomIndex,
      ),
    );
  }
}
