class CountryModel {
  final String id;
  final String country;
  final String? flag;

  CountryModel({
    required this.id,
    required this.country,
    this.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      flag: json['flag']?.toString(),
    );
  }
}