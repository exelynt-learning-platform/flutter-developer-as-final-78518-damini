import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/country_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late CountryRepository repository;

 setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    repository = CountryRepository(mockClient);
  });

  test('getCountries should return countries when API succeeds',
() async {
    final response = http.Response(
      jsonEncode([
        {
          'id': '1',
          'country': 'India',
          'flag': '🇮🇳',
        },
        {
          'id': '2',
          'country': 'USA',
          'flag': '🇺🇸',
        },
      ]),
      200,
      headers: {
        'content-type': 'application/json; charset=utf-8',
      },
    );

    when(
      () => mockClient.get(any()),
    ).thenAnswer((_) async => response);

    final countries = await repository.getCountries();

    expect(countries.length, 2);
    expect(countries.first.id, '1');
    expect(countries.first.country, 'India');
    expect(countries.first.flag, '🇮🇳');

    verify(
      () => mockClient.get(any()),
    ).called(1);
  },
);

  test('getCountries should throw exception when API fails', () async {
    final response = http.Response(
      'Server Error',
      500,
    );

    when(
      () => mockClient.get(any()),
    ).thenAnswer((_) async => response);

    expect(
      () => repository.getCountries(),
      throwsException,
    );
  });
}