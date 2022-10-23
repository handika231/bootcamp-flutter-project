import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upload_file_app/application/application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const Application());
}
