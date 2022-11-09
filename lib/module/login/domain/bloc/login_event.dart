part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.login({
    required String domainUrl,
  }) = _Login;
  const factory LoginEvent.refreshToken() = _RefreshToken;
  const factory LoginEvent.logout() = _Logout;
}
