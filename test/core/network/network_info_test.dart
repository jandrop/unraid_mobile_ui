import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unmobile/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late NetworkInfo networkInfo;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfo(mockConnectivity);
  });

  group('NetworkInfo', () {
    group('isConnected', () {
      test('should return true when connected to WiFi', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        final result = await networkInfo.isConnected;

        expect(result, true);
        verify(() => mockConnectivity.checkConnectivity()).called(1);
      });

      test('should return true when connected to mobile', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });

      test('should return true when connected to ethernet', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.ethernet]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });

      test('should return false when not connected', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await networkInfo.isConnected;

        expect(result, false);
      });

      test('should return true when connected to multiple networks', () async {
        when(() => mockConnectivity.checkConnectivity()).thenAnswer(
            (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });
    });

    group('onConnectivityChanged', () {
      test('should emit true when connectivity changes to WiFi', () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => Stream.value([ConnectivityResult.wifi]),
        );

        expect(
          networkInfo.onConnectivityChanged,
          emits(true),
        );
      });

      test('should emit false when connectivity changes to none', () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => Stream.value([ConnectivityResult.none]),
        );

        expect(
          networkInfo.onConnectivityChanged,
          emits(false),
        );
      });

      test('should emit connectivity changes stream', () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => Stream.fromIterable([
            [ConnectivityResult.none],
            [ConnectivityResult.wifi],
            [ConnectivityResult.none],
            [ConnectivityResult.mobile],
          ]),
        );

        expect(
          networkInfo.onConnectivityChanged,
          emitsInOrder([false, true, false, true]),
        );
      });
    });
  });
}
