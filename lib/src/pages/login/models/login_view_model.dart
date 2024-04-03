class LoginViewModel {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final bool isAdmin;

  LoginViewModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
    required this.isAdmin,
  });

  factory LoginViewModel.fromJson(Map<String, dynamic> json){
    return LoginViewModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      password: json['password'],
      isAdmin: json['isAdmin'],);
  }
}