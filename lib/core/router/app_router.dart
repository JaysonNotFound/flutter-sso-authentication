import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../module/home/page/home_page.dart';
import '../../module/login/page/login_page.dart';
import '../../module/splash/page/splash_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      path: '/splash',
      page: SplashPage,
      initial: true,
    ),
    AutoRoute(
      path: '/login',
      page: LoginPage,
    ),
    AutoRoute(
      path: '/home',
      page: HomePage,
    ),
  ],
)
class AppRouter extends _$AppRouter {}
