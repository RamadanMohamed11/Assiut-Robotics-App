/*

class AddProductService {
  Future<ProductModel> addProduct({required ProductModel product}) async {
    String baseAddress = "https://fakestoreapi.com";
    final dynamic data =
        await API().post(url: "https://fakestoreapi.com/products", body: {
      "title": product.title,
      "price": product.price as String,
      "description": product.description,
      "image": product.image
    });
    return ProductModel.fromJson(data);
  }
}

*/

import 'package:robotics_app/helper/api.dart';

class LoginService {
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/members/login',
      body: {"email": email, "password": password},
      token: null,
    );
    print(data);
    return data;
  }
}
