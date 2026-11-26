import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PreferencesService preferences = await PreferencesService.create();
  runApp(SakeenaApp(preferences: preferences));
}
