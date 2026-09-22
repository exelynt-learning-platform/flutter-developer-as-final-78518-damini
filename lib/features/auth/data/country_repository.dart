import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/country_model.dart';
import '../../../core/constants/app_constants.dart';

class CountryRepository {
  final http.Client client;

  CountryRepository(this.client);

  Future<List<CountryModel>> getCountries() async {
    final response = await client.get(
      Uri.parse(AppConstants.employeeApi),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => CountryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}