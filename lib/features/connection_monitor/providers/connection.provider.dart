import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = FutureProvider((ref) async {
  final connectivity = Connectivity();
  final checkConnectivity = connectivity.onConnectivityChanged;
  return checkConnectivity;
});

final connectivityStreamProvider = StreamProvider((ref) {
  final connectivity = Connectivity();
  final onConnectivityChanged = connectivity.onConnectivityChanged;
  return onConnectivityChanged;
});
