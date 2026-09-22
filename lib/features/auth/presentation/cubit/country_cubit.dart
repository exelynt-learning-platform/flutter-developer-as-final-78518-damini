import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/country_repository.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/country_model.dart';

abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<CountryModel> countries;

  CountryLoaded(this.countries);
}

class CountryError extends CountryState {
  final String message;

  CountryError(this.message);
}

class CountryCubit extends Cubit<CountryState> {
  final CountryRepository repository;

  CountryCubit(this.repository) : super(CountryInitial());

  Future<void> getCountries() async {
    emit(CountryLoading());

    try {
      final countries = await repository.getCountries();

      emit(CountryLoaded(countries));
    } catch (e) {
      emit(
        CountryError(
          e.toString(),
        ),
      );
    }
  }
}