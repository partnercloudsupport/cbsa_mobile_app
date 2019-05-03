class User{
  int id;
  String name;
  String email;

  User({this.id,this.name, this.email,});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class Auth{
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  Auth({this.tokenType,this.expiresIn,this.accessToken, this.refreshToken});

  factory Auth.fromJson(Map<String, dynamic> json){
    return Auth(
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class LoginModel{
  final String email;
  final String password;
  final String device_token;

  LoginModel({this.email,this.password,this.device_token});

  LoginModel.fromJson(Map<String,dynamic> json):
    email=json['email'],
    password=json['password'],
    device_token=json['device_token'];


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['email'] =  email;
    map['password'] =  password;
    map['device_token'] = device_token;
    return map;
  }
}


class LoginReturnModel{
  final int status;
  final String token;
  // final Auth auth;
  final User user;

  //LoginReturnModel({this.status, this.auth,this.user});
  LoginReturnModel({this.status, this.token,this.user});

  factory LoginReturnModel.fromJson(Map<String, dynamic> parsedJson){
    return LoginReturnModel(
      status: parsedJson['status'],        
      // auth: Auth.fromJson(parsedJson['auth']),
      user: User.fromJson(parsedJson['user'])
    );
  }
}