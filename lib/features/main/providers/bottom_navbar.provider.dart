import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/features/main/main_screen.dart';

class BottomNavbarStateNotifier extends StateNotifier<NavItem> {
  BottomNavbarStateNotifier() : super(NavItem.home);
  void gotoSection(NavItem item) {
    state = item;
  }
}

final bottomNavbarProvider =
    StateNotifierProvider<BottomNavbarStateNotifier, NavItem>(
  (ref) => BottomNavbarStateNotifier(),
);
