import 'dart:convert';

import 'package:ecommerceapp/Repository/Api/api_client.dart';
import 'package:ecommerceapp/Repository/Model/get_all_product_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class GetAllProductListApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllProductsListModel> postuserdata() async {
    var body = {};
    String trendingpath = 'products';

    Response response = await apiClient.invokeAPI(trendingpath, 'GET', body);

    if (kDebugMode) {
      print("Response: ${response.body}");
    }

    return GetAllProductsListModel.fromJson(jsonDecode(response.body));
  }
}
