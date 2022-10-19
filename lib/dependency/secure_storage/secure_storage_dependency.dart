import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class SecureStorageDependency {
  Future<String?> get({
    required String key,
  }) {
    final _secureStorage = FlutterSecureStorage();
    return _secureStorage.read(
      key: key,
    );
  }

  Future<void> insert({
    required String key,
    String? value,
  }) {
    final _secureStorage = FlutterSecureStorage();
    return _secureStorage.write(
      key: key,
      value: value,
    );
  }

  Future<void> delete({
    required String key,
  }) {
    final _secureStorage = FlutterSecureStorage();
    return _secureStorage.delete(
      key: key,
    );
  }
}
