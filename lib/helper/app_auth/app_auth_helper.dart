import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injectable/injectable.dart';

import '../../dependency/app_auth/app_auth_dependency.dart';

@injectable
class AppAuthHelper {
  final AppAuthDependency _appAuthDependency;

  AppAuthHelper({
    required AppAuthDependency appAuthDependency,
  }) : _appAuthDependency = appAuthDependency;

  Future<Either<PlatformException?, AuthorizationTokenResponse?>> authenticate({
    required String clientId,
    required String redirectUrl,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    try {
      final result = await _appAuthDependency.authenticate(
        clientId: clientId,
        redirectUrl: redirectUrl,
        serviceConfiguration: serviceConfiguration,
      );
      return Right(result);
    } catch (exception) {
      if (exception is PlatformException) return Left(exception);
      rethrow;
    }
  }

  Future<Either<PlatformException?, TokenResponse?>> refreshToken({
    required String clientId,
    required String redirectUrl,
    required String refreshToken,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    try {
      final result = await _appAuthDependency.refreshToken(
        clientId: clientId,
        redirectUrl: redirectUrl,
        refreshToken: refreshToken,
        serviceConfiguration: serviceConfiguration,
      );
      return Right(result);
    } catch (exception) {
      if (exception is PlatformException) return Left(exception);
      rethrow;
    }
  }

  Future<Either<PlatformException?, EndSessionResponse?>> logout({
    required String idToken,
    required String postLogoutRedirectUrl,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    try {
      final result = await _appAuthDependency.logout(
        idToken: idToken,
        postLogoutRedirectUrl: postLogoutRedirectUrl,
        serviceConfiguration: serviceConfiguration,
      );
      return Right(result);
    } catch (exception) {
      if (exception is PlatformException) return Left(exception);
      rethrow;
    }
  }
}
