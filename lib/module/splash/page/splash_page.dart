import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../domain/bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) => state.maybeWhen(
        authorized: () => AutoRouter.of(context).replace(HomePageRoute()),
        orElse: () => AutoRouter.of(context).replace(LoginPageRoute()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  'Flutter SSO Authentication'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
