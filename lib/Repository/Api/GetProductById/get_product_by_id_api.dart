import 'dart:convert';

import 'package:ecommerceapp/Repository/Api/api_client.dart';
import 'package:ecommerceapp/Repository/Model/get_product_by_id_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class GetProductByIdApi {
  ApiClient apiClient = ApiClient();

  Future<GetProductByIdModel> postuserdata({required String id}) async {
    var body = {};
    String trendingpath = 'products/$id';

    Response response = await apiClient.invokeAPI(trendingpath, 'GET', body);

    if (kDebugMode) {
      print("Response: ${response.body}");
    }

    return GetProductByIdModel.fromJson(jsonDecode(response.body));
  }
}
