import 'package:get/get.dart';

class User extends GetxController {
  String? accessToken;
  String? refreshToken;
  String? email;
  String? name;
  String? lastName;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? role;
  String? status;
  String? createdAt;
  String? updatedAt;

  User({
    this.accessToken,
    this.refreshToken,
    this.email,
    this.name,
    this.lastName,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    email = json['email'];
    name = json['name'];
    lastName = json['lastName'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
    role = json['role'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['email'] = email;
    data['name'] = name;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postalCode'] = postalCode;
    data['role'] = role;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  static User getUser() {
    return User(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      email: 'email',
      name: 'name',
      lastName: 'lastName',
      phone: 'phone',
      address: 'address',
      city: 'city',
      state: 'state',
      country: 'country',
      postalCode: 'postalCode',
      role: 'role',
      status: 'status',
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    );
  }
}
