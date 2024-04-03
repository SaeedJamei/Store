class SignupDto{
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final bool isAdmin;

  SignupDto({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
    required this.isAdmin,
  });

  Map<String , dynamic> toJson(){
    return{
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}