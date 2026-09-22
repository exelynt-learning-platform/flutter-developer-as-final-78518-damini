class Employee {
  final String? id;
  final String name;
  final String emailId;
  final String mobile;
  final String country;
  final String state;
  final String district;

  Employee({
    this.id,
    required this.name,
    required this.emailId,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      emailId: json['emailId']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emailId': emailId,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
    };
  }
}