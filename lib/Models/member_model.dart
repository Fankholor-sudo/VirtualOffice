class MemberModel {
  final String MemberID;
  final String OfficeID;
  final String FirstName;
  final String LastName;
  final String Avatar;

  const MemberModel({
    required this.MemberID,
    required this.OfficeID,
    required this.FirstName,
    required this.LastName,
    required this.Avatar,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'MemberID': String MemberID,
        'OfficeID': String OfficeID,
        'FirstName': String FirstName,
        'LastName': String LastName,
        'Avatar': String Avatar,
      } =>
        MemberModel(
          MemberID: MemberID,
          OfficeID: OfficeID,
          FirstName: FirstName,
          LastName: LastName,
          Avatar: Avatar,
        ),
      _ => throw const FormatException('Failed to load member.'),
    };
  }
}
