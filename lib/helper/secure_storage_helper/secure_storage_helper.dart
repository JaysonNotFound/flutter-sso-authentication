import 'package:injectable/injectable.dart';

import '../../dependency/secure_storage/secure_storage_dependency.dart';

@injectable
class SecureStorageHelper {
  final SecureStorageDependency _secureStorageDependency;

  SecureStorageHelper({
    required SecureStorageDependency secureStorageDependency,
  }) : _secureStorageDependency = secureStorageDependency;

  Future<String?> get({
    required String key,
  }) async {
    try {
      final result = await _secureStorageDependency.get(key: key);
      return result;
    } catch (exception) {
      return null;
    }
  }

  Future<bool> insert({
    required String key,
    required value,
  }) async {
    try {
      await _secureStorageDependency.insert(
        key: key,
        value: value,
      );
      return true;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> delete({
    required String key,
  }) async {
    try {
      await _secureStorageDependency.delete(key: key);
      return true;
    } catch (exception) {
      return false;
    }
  }
}
