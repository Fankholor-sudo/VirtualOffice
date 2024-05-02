class OfficeModel {
  final int MaxCapacity;
  final String OfficeID;
  final String OfficeName;
  final String PhoneNumber;
  final String OfficeColor;
  final String Address;
  final String Email;

  const OfficeModel({
    required this.MaxCapacity,
    required this.OfficeID,
    required this.OfficeName,
    required this.PhoneNumber,
    required this.OfficeColor,
    required this.Address,
    required this.Email,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'MaxCapacity': int MaxCapacity,
        'OfficeID': String OfficeID,
        'OfficeName': String OfficeName,
        'PhoneNumber': String PhoneNumber,
        'OfficeColor': String OfficeColor,
        'Address': String Address,
        'Email': String Email,
      } =>
        OfficeModel(
          MaxCapacity: MaxCapacity,
          OfficeID: OfficeID,
          OfficeName: OfficeName,
          PhoneNumber: PhoneNumber,
          OfficeColor: OfficeColor,
          Address: Address,
          Email: Email,
        ),
      _ => throw const FormatException('Failed to load office.'),
    };
  }
}
