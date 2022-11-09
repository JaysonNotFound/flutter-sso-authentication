import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../helper/app_auth/app_auth_helper.dart';
import '../../../../helper/secure_storage_helper/secure_storage_helper.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AppAuthHelper _appAuthHelper;
  final SecureStorageHelper _secureStorageHelper;

  LoginBloc({
    required AppAuthHelper appAuthHelper,
    required SecureStorageHelper secureStorageHelper,
  })  : _appAuthHelper = appAuthHelper,
        _secureStorageHelper = secureStorageHelper,
        super(_Initial()) {
    on<LoginEvent>((event, emit) async {
      await event.when(
        login: (domainUrl) => _handleLogin(
          emit,
          domainUrl: domainUrl,
        ),
        refreshToken: () => _handleRefreshToken(emit),
        logout: () => _handleLogout(emit),
      );
    });
  }

  FutureOr<void> _handleLogin(
    Emitter emit, {
    required String domainUrl,
  }) async {
    emit(const LoginState.loading());
    final subDomain = domainUrl.split('.')[0];

    const apiUrl = 'https://sso-test.sprout.ph/realms';
    const clientId = 'SproutSSO';
    final uri = '$apiUrl/$subDomain/protocol/openid-connect';

    final result = await _appAuthHelper.authenticate(
      clientId: clientId,
      redirectUrl: 'sprout-dev://callback',
      serviceConfiguration: AuthorizationServiceConfiguration(
        authorizationEndpoint: '$uri/auth',
        tokenEndpoint: '$uri/token',
        endSessionEndpoint: '$uri/logout',
      ),
    );

    final _response = result.getOrElse(() => null);

    if (_response == null) {
      return emit(LoginState.loginFailed());
    }
    await _secureStorageHelper.insert(
      key: 'domainUrl',
      value: domainUrl,
    );
    await _secureStorageHelper.insert(
      key: 'idToken',
      value: _response.idToken,
    );
    await _secureStorageHelper.insert(
      key: 'accessToken',
      value: _response.accessToken,
    );
    await _secureStorageHelper.insert(
      key: 'refreshToken',
      value: _response.refreshToken,
    );
    await _secureStorageHelper.insert(
      key: 'expiresIn',
      value: _response.accessTokenExpirationDateTime!.toIso8601String(),
    );

    return emit(LoginState.loginSuccess());
  }

  FutureOr<void> _handleLogout(Emitter emit) async {
    emit(LoginState.loading());

    final domainUrl = await _secureStorageHelper.get(key: 'domainUrl');
    final idToken = await _secureStorageHelper.get(key: 'idToken');
    if (domainUrl == null || idToken == null) {
      await _deleteToken();
      return emit(LoginState.logoutSuccess());
    }

    final subDomain = domainUrl.split('.')[0];

    const apiUrl = 'https://sso-test.sprout.ph/realms';
    final uri = '$apiUrl/$subDomain/protocol/openid-connect';

    final result = await _appAuthHelper.logout(
      idToken: idToken,
      postLogoutRedirectUrl: 'sprout-dev://callback',
      serviceConfiguration: AuthorizationServiceConfiguration(
        authorizationEndpoint: '$uri/auth',
        tokenEndpoint: '$uri/token',
        endSessionEndpoint: '$uri/logout',
      ),
    );

    final _response = result.getOrElse(() => null);

    if (_response == null) {
      return emit(LoginState.logoutFailed());
    }

    await _deleteToken();
    return emit(LoginState.logoutSuccess());
  }

  Future<void> _deleteToken() async {
    await _secureStorageHelper.delete(key: 'idToken');
    await _secureStorageHelper.delete(key: 'accessToken');
    await _secureStorageHelper.delete(key: 'refreshToken');
    await _secureStorageHelper.delete(key: 'expiresIn');
  }

  FutureOr<void> _handleRefreshToken(Emitter emit) async {
    emit(LoginState.loading());

    final domainUrl = await _secureStorageHelper.get(key: 'domainUrl');
    final refreshToken = await _secureStorageHelper.get(key: 'refreshToken');

    final subDomain = domainUrl!.split('.')[0];

    const apiUrl = 'https://sso-test.sprout.ph/realms';
    const clientId = 'SproutSSO';
    final uri = '$apiUrl/$subDomain/protocol/openid-connect';
    final result = await _appAuthHelper.refreshToken(
      clientId: clientId,
      redirectUrl: 'sprout-dev://callback',
      refreshToken: refreshToken!,
      serviceConfiguration: AuthorizationServiceConfiguration(
        authorizationEndpoint: '$uri/auth',
        tokenEndpoint: '$uri/token',
        endSessionEndpoint: '$uri/logout',
      ),
    );
    final _response = result.getOrElse(() => null);

    if (_response == null) {
      return emit(LoginState.tokenRefreshFailed());
    }

    await _secureStorageHelper.insert(
      key: 'idToken',
      value: _response.idToken,
    );
    await _secureStorageHelper.insert(
      key: 'accessToken',
      value: _response.accessToken,
    );
    await _secureStorageHelper.insert(
      key: 'refreshToken',
      value: _response.refreshToken,
    );
    await _secureStorageHelper.insert(
      key: 'expiresIn',
      value: _response.accessTokenExpirationDateTime!.toIso8601String(),
    );

    return emit(LoginState.tokenRefreshSuccess());
  }
}
