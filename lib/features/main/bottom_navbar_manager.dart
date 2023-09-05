import 'package:flutter/cupertino.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:wow_shopping/models/nav_item.dart';

class NavbarManager extends ChangeNotifier {
  NavbarManager(this._selected) {
    gotoSectionCommand = Command.createSyncNoResult((x) {
      _selected = x;
      notifyListeners();
    },
    errorFilter: const ErrorHandlerLocalAndGlobal(),
    debugName:  'gotoSection Command!');
  }

  late final Command<NavItem, void> gotoSectionCommand;
  NavItem _selected;
  NavItem get selected => _selected;
}
