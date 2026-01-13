// To parse this JSON data, do
//
//     final updateItemByIdModel = updateItemByIdModelFromJson(jsonString);

import 'dart:convert';

UpdateItemByIdModel updateItemByIdModelFromJson(String str) => UpdateItemByIdModel.fromJson(json.decode(str));

String updateItemByIdModelToJson(UpdateItemByIdModel data) => json.encode(data.toJson());

class UpdateItemByIdModel {
    int id;
    String title;
    double price;
    // FIX: Changed from int to double
    double discountPercentage; 
    int stock;
    double rating;
    List<String> images;
    String thumbnail;
    String description;
    String brand;
    String category;

    UpdateItemByIdModel({
        required this.id,
        required this.title,
        required this.price,
        required this.discountPercentage,
        required this.stock,
        required this.rating,
        required this.images,
        required this.thumbnail,
        required this.description,
        required this.brand,
        required this.category,
    });

    factory UpdateItemByIdModel.fromJson(Map<String, dynamic> json) => UpdateItemByIdModel(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        // FIX: Safely cast to double
        discountPercentage: json["discountPercentage"]?.toDouble() ?? 0.0, 
        // Safely ensure it is an integer (in case it returns '58.0')
        stock: json["stock"] is double ? (json["stock"] as double).toInt() : json["stock"] as int,
        rating: json["rating"]?.toDouble(),
        images: List<String>.from(json["images"].map((x) => x)),
        thumbnail: json["thumbnail"],
        description: json["description"],
        brand: json["brand"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "discountPercentage": discountPercentage,
        "stock": stock,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x)),
        "thumbnail": thumbnail,
        "description": description,
        "brand": brand,
        "category": category,
    };
}