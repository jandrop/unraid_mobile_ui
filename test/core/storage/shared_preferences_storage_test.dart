import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unmobile/core/storage/shared_preferences_storage.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late SharedPreferencesStorage storage;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storage = SharedPreferencesStorage(mockPrefs);
  });

  group('SharedPreferencesStorage', () {
    group('getString', () {
      test('should return string value when key exists', () async {
        const key = 'test_key';
        const value = 'test_value';
        when(() => mockPrefs.getString(key)).thenReturn(value);

        final result = await storage.getString(key);

        expect(result, value);
        verify(() => mockPrefs.getString(key)).called(1);
      });

      test('should return null when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.getString(key)).thenReturn(null);

        final result = await storage.getString(key);

        expect(result, null);
      });
    });

    group('setString', () {
      test('should return true when value is set successfully', () async {
        const key = 'test_key';
        const value = 'test_value';
        when(() => mockPrefs.setString(key, value))
            .thenAnswer((_) async => true);

        final result = await storage.setString(key, value);

        expect(result, true);
        verify(() => mockPrefs.setString(key, value)).called(1);
      });
    });

    group('getInt', () {
      test('should return int value when key exists', () async {
        const key = 'test_key';
        const value = 42;
        when(() => mockPrefs.getInt(key)).thenReturn(value);

        final result = await storage.getInt(key);

        expect(result, value);
      });

      test('should return null when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.getInt(key)).thenReturn(null);

        final result = await storage.getInt(key);

        expect(result, null);
      });
    });

    group('setInt', () {
      test('should return true when value is set successfully', () async {
        const key = 'test_key';
        const value = 42;
        when(() => mockPrefs.setInt(key, value)).thenAnswer((_) async => true);

        final result = await storage.setInt(key, value);

        expect(result, true);
        verify(() => mockPrefs.setInt(key, value)).called(1);
      });
    });

    group('getBool', () {
      test('should return bool value when key exists', () async {
        const key = 'test_key';
        const value = true;
        when(() => mockPrefs.getBool(key)).thenReturn(value);

        final result = await storage.getBool(key);

        expect(result, value);
      });

      test('should return null when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.getBool(key)).thenReturn(null);

        final result = await storage.getBool(key);

        expect(result, null);
      });
    });

    group('setBool', () {
      test('should return true when value is set successfully', () async {
        const key = 'test_key';
        const value = true;
        when(() => mockPrefs.setBool(key, value))
            .thenAnswer((_) async => true);

        final result = await storage.setBool(key, value);

        expect(result, true);
        verify(() => mockPrefs.setBool(key, value)).called(1);
      });
    });

    group('getDouble', () {
      test('should return double value when key exists', () async {
        const key = 'test_key';
        const value = 3.14;
        when(() => mockPrefs.getDouble(key)).thenReturn(value);

        final result = await storage.getDouble(key);

        expect(result, value);
      });

      test('should return null when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.getDouble(key)).thenReturn(null);

        final result = await storage.getDouble(key);

        expect(result, null);
      });
    });

    group('setDouble', () {
      test('should return true when value is set successfully', () async {
        const key = 'test_key';
        const value = 3.14;
        when(() => mockPrefs.setDouble(key, value))
            .thenAnswer((_) async => true);

        final result = await storage.setDouble(key, value);

        expect(result, true);
        verify(() => mockPrefs.setDouble(key, value)).called(1);
      });
    });

    group('getStringList', () {
      test('should return string list when key exists', () async {
        const key = 'test_key';
        const value = ['item1', 'item2', 'item3'];
        when(() => mockPrefs.getStringList(key)).thenReturn(value);

        final result = await storage.getStringList(key);

        expect(result, value);
      });

      test('should return null when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.getStringList(key)).thenReturn(null);

        final result = await storage.getStringList(key);

        expect(result, null);
      });
    });

    group('setStringList', () {
      test('should return true when value is set successfully', () async {
        const key = 'test_key';
        const value = ['item1', 'item2', 'item3'];
        when(() => mockPrefs.setStringList(key, value))
            .thenAnswer((_) async => true);

        final result = await storage.setStringList(key, value);

        expect(result, true);
        verify(() => mockPrefs.setStringList(key, value)).called(1);
      });
    });

    group('remove', () {
      test('should return true when key is removed successfully', () async {
        const key = 'test_key';
        when(() => mockPrefs.remove(key)).thenAnswer((_) async => true);

        final result = await storage.remove(key);

        expect(result, true);
        verify(() => mockPrefs.remove(key)).called(1);
      });
    });

    group('clear', () {
      test('should return true when all values are cleared', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);

        final result = await storage.clear();

        expect(result, true);
        verify(() => mockPrefs.clear()).called(1);
      });
    });

    group('containsKey', () {
      test('should return true when key exists', () async {
        const key = 'test_key';
        when(() => mockPrefs.containsKey(key)).thenReturn(true);

        final result = await storage.containsKey(key);

        expect(result, true);
        verify(() => mockPrefs.containsKey(key)).called(1);
      });

      test('should return false when key does not exist', () async {
        const key = 'test_key';
        when(() => mockPrefs.containsKey(key)).thenReturn(false);

        final result = await storage.containsKey(key);

        expect(result, false);
      });
    });

    group('getKeys', () {
      test('should return all keys', () async {
        final keys = {'key1', 'key2', 'key3'};
        when(() => mockPrefs.getKeys()).thenReturn(keys);

        final result = await storage.getKeys();

        expect(result, keys);
        verify(() => mockPrefs.getKeys()).called(1);
      });

      test('should return empty set when no keys exist', () async {
        final keys = <String>{};
        when(() => mockPrefs.getKeys()).thenReturn(keys);

        final result = await storage.getKeys();

        expect(result, isEmpty);
      });
    });
  });
}
