import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppAuthDependency {
  Future<AuthorizationTokenResponse?> authenticate({
    required String clientId,
    required String redirectUrl,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    const _appAuth = FlutterAppAuth();
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        serviceConfiguration: serviceConfiguration,
        scopes: ['openid'],
      ),
    );

    return result;
  }

  Future<TokenResponse?> refreshToken({
    required String clientId,
    required String redirectUrl,
    required String refreshToken,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    const _appAuth = FlutterAppAuth();

    final result = await _appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        refreshToken: refreshToken,
        serviceConfiguration: serviceConfiguration,
        scopes: ['openid'],
      ),
    );

    return result;
  }

  Future<EndSessionResponse?> logout({
    required String idToken,
    required String postLogoutRedirectUrl,
    required AuthorizationServiceConfiguration serviceConfiguration,
  }) async {
    const _appAuth = FlutterAppAuth();

    final result = await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: postLogoutRedirectUrl,
        serviceConfiguration: serviceConfiguration,
        preferEphemeralSession: true,
      ),
    );

    return result;
  }
}
