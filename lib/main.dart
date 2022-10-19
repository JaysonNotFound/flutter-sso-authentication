import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/config/dependency_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await GetIt.instance.allReady();

  runZonedGuarded(
    () {
      runApp(const App());
    },
    (error, stackTrace) {},
  );
}
