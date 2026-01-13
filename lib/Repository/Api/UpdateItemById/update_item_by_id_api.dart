import 'dart:convert';
import 'package:ecommerceapp/Repository/Api/api_client.dart';
import 'package:ecommerceapp/Repository/Model/update_item_by_id_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class UpdateItemByIdApi {
  ApiClient apiClient = ApiClient();

  Future<UpdateItemByIdModel> postuserdata({
    required String id,
    required int idInt, // Keep for potential use, but exclude from body
    required String title,
    required String description,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String brand,
  }) async {
    String trendingpath = 'products/$id';

    // ***************************************************************
    // FIX: Exclude the ID from the request body as it's in the URL path.
    // ***************************************************************
    final Map<String, dynamic> requestBody = {
      // 'id': idInt, <--- REMOVED THIS LINE
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
    };

    Response response = await apiClient.invokeAPI(
      trendingpath,
      'PUT',
      requestBody,
    );

    if (kDebugMode) {
      print("Update Request Body: $requestBody");
      print("Update Response: ${response.body}");
    }

    if (response.statusCode == 404) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Product not found.',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = _decodeBodyBytes(response);
      throw Exception(errorMessage);
    }

    return UpdateItemByIdModel.fromJson(jsonDecode(response.body));
  }

  // You need to copy this helper method from your ApiClient to use it here for error handling
  String _decodeBodyBytes(http.Response response) {
    var contentType = response.headers['content-type'];
    if (contentType != null && contentType.contains("application/json")) {
      try {
        final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;

        if (bodyJson.containsKey('message') && bodyJson['message'] is String) {
          return bodyJson['message'];
        }

        if (bodyJson.containsKey('error') && bodyJson['error'] is String) {
          return bodyJson['error'];
        }
        return response.body;
      } catch (e) {
        return response.body;
      }
    } else {
      return response.body;
    }
  }
}
