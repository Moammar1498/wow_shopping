import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/bottom_navbar_manager.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const MainScreen({super.key});

  static MainScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // NavItem _selected = NavItem.home;

  // void gotoSection(NavItem item) {
  //   setState(() => _selected = item);
  // }

  NavbarManager navbarManager = NavbarManager(NavItem.home);
  @override
  Widget build(BuildContext context) {
    final navbarvalue = watch(navbarManager).selected;
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: navbarvalue.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: navbarManager.gotoSectionCommand,
              selected: navbarvalue,
            ),
          ],
        ),
      ),
    );
  }
}
