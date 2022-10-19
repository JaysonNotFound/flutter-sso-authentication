import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'module/login/domain/bloc/login_bloc.dart';
import 'module/splash/domain/bloc/splash_bloc.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) {
            final _bloc = GetIt.I<SplashBloc>();
            _bloc.add(SplashEvent.initialize());
            return _bloc;
          },
        ),
        BlocProvider<LoginBloc>(
          create: (context) => GetIt.I<LoginBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        builder: (context, widget) {
          return Stack(
            children: <Widget>[
              widget!,
              const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
