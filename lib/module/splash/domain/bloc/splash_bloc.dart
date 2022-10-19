import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../helper/secure_storage_helper/secure_storage_helper.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SecureStorageHelper _secureStorageHelper;
  SplashBloc({
    required SecureStorageHelper secureStorageHelper,
  })  : _secureStorageHelper = secureStorageHelper,
        super(_Initial()) {
    on<SplashEvent>((event, emit) async {
      await event.when(
        initialize: () => _handleInitialize(emit),
      );
    });
  }

  FutureOr<void> _handleInitialize(Emitter emit) async {
    await Future.delayed(Duration(seconds: 1));
    final accessToken = await _secureStorageHelper.get(key: 'accessToken');
    if (accessToken == null || accessToken.isEmpty) {
      return emit(SplashState.unauthorized());
    }
    return emit(SplashState.authorized());
  }
}
