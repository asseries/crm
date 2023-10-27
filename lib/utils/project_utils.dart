
import 'package:crm/main.dart';
import 'package:flutter/material.dart';

Future<int> getAudioDuration(String path) async {
  WidgetsFlutterBinding.ensureInitialized();
  return await MyApp.platform.invokeMethod("getAudioDuration", {"path": path});
}