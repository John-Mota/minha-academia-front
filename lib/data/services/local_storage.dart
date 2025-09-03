import 'package:minha_academia_front/data/exceptions/exceptions.dart';
import 'package:minha_academia_front/utils/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:result_dart/result_dart.dart';

class LocalStorage {
  AsyncResultDart<String, AppException> saveData(
    String key,
    String value,
  ) async {
    try {
      final shared = await SharedPreferences.getInstance();
      shared.setString(key, value);
      return Success(value);
    } catch (e) {
      return const Failure(LocalStorageException('Failed to save data'));
    }
  }

  AsyncResultDart<String, AppException> getData(String key) async {
    try {
      final shared = await SharedPreferences.getInstance();
      final value = shared.getString(key);
      if (value == null) {
        return Failure(EmptyLocalStorageException(key));
      }
      return Success(value);
    } catch (e) {
      return const Failure(LocalStorageException('Failed to get data'));
    }
  }

  AsyncResultDart<Unit, AppException> removeData(String key) async {
    try {
      final shared = await SharedPreferences.getInstance();
      shared.remove(key);
      return Success.unit();
    } catch (e) {
      return const Failure(LocalStorageException('Failed to remove data'));
    }
  }
}
