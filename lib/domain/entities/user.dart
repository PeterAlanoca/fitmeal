class User {
  final String name;
  final String lastName;
  final String email;
  final String birthdate;
  final String? accessToken;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.birthdate,
    this.accessToken,
  });
}
