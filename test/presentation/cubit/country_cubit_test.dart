import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/country_repository.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/country_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/country_cubit.dart';

class MockCountryRepository extends Mock
    implements CountryRepository {}

void main() {
  late MockCountryRepository mockRepository;
  late CountryCubit countryCubit;

  final countries = [
    CountryModel(
      id: '1',
      country: 'India',
      flag: '🇮🇳',
    ),
    CountryModel(
      id: '2',
      country: 'USA',
      flag: '🇺🇸',
    ),
  ];

  setUp(() {
    mockRepository = MockCountryRepository();
    countryCubit = CountryCubit(mockRepository);
  });

  tearDown(() {
    countryCubit.close();
  });

  test('initial state should be CountryInitial', () {
    expect(
      countryCubit.state,
      isA<CountryInitial>(),
    );
  });

  test(
    'getCountries should emit loading and loaded state',
    () async {
      when(
        () => mockRepository.getCountries(),
      ).thenAnswer(
        (_) async => countries,
      );

      final states = <CountryState>[];

      final subscription = countryCubit.stream.listen(
        states.add,
      );

      await countryCubit.getCountries();

      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);

      expect(
        states[0],
        isA<CountryLoading>(),
      );

      expect(
        states[1],
        isA<CountryLoaded>(),
      );

      final loadedState =
          states[1] as CountryLoaded;

      expect(
        loadedState.countries.length,
        2,
      );

      expect(
        loadedState.countries[0].country,
        'India',
      );

      expect(
        loadedState.countries[1].country,
        'USA',
      );

      verify(
        () => mockRepository.getCountries(),
      ).called(1);

      await subscription.cancel();
    },
  );

  test(
    'getCountries should emit error when repository fails',
    () async {
      when(
        () => mockRepository.getCountries(),
      ).thenThrow(
        Exception('API error'),
      );

      final states = <CountryState>[];

      final subscription = countryCubit.stream.listen(
        states.add,
      );

      await countryCubit.getCountries();

      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);

      expect(
        states[0],
        isA<CountryLoading>(),
      );

      expect(
        states[1],
        isA<CountryError>(),
      );

      final errorState =
          states[1] as CountryError;

      expect(
        errorState.message,
        contains('API error'),
      );

      verify(
        () => mockRepository.getCountries(),
      ).called(1);

      await subscription.cancel();
    },
  );
}