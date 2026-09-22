import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/country_repository.dart';
import '../../model/country_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryState {
  final bool isLoading;
  final List<CountryModel> countries;
  final String? error;

  const CountryState({
    this.isLoading = false,
    this.countries = const [],
    this.error,
  });
}

class CountryCubit extends Cubit<CountryState> {
  final CountryRepository repository;

  CountryCubit(this.repository) : super(const CountryState());

  Future<void> getCountries() async {
    emit(
      CountryState(
        isLoading: true,
        countries: state.countries,
      ),
    );

    try {
      final countries = await repository.getCountries();

      emit(
        CountryState(
          isLoading: false,
          countries: countries,
        ),
      );
    } catch (e) {
      emit(
        CountryState(
          isLoading: false,
          countries: state.countries,
          error: e.toString(),
        ),
      );
    }
  }
}