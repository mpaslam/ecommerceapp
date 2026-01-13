// To parse this JSON data, do
//
//     final getProductByIdModel = getProductByIdModelFromJson(jsonString);

import 'dart:convert';

GetProductByIdModel getProductByIdModelFromJson(String str) =>
    GetProductByIdModel.fromJson(json.decode(str));

String getProductByIdModelToJson(GetProductByIdModel data) =>
    json.encode(data.toJson());

class GetProductByIdModel {
  int id;
  String title;
  String description;
  Category category;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<String> tags;
  String? brand;
  String sku;
  int weight;
  Dimensions dimensions;
  String warrantyInformation;
  String shippingInformation;
  AvailabilityStatus availabilityStatus;
  List<Review> reviews;
  ReturnPolicy returnPolicy;
  int minimumOrderQuantity;
  Meta meta;
  List<String> images;
  String thumbnail;

  GetProductByIdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  factory GetProductByIdModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawStock = json["stock"];
    final int stockValue = rawStock is double
        ? rawStock.toInt()
        : rawStock as int? ?? 0;

    // Fallback for enums to prevent Null check operator used on a null value
    final Category defaultCategory =
        Category.BEAUTY; // Or any default valid category
    final AvailabilityStatus defaultAvailability = AvailabilityStatus.IN_STOCK;
    final ReturnPolicy defaultReturnPolicy = ReturnPolicy.NO_RETURN_POLICY;

    final String? categoryKey = json["category"];
    final String? availabilityKey = json["availabilityStatus"];
    final String? returnPolicyKey = json["returnPolicy"];

    return GetProductByIdModel(
      id: json["id"] as int? ?? 0,
      title: json["title"] ?? '',
      description: json["description"] ?? '',

      // FIX: Robust enum mapping with fallback
      category:
          categoryKey != null && categoryValues.map.containsKey(categoryKey)
          ? categoryValues.map[categoryKey]!
          : defaultCategory,

      price: json["price"]?.toDouble() ?? 0.0,
      discountPercentage: json["discountPercentage"]?.toDouble() ?? 0.0,
      rating: json["rating"]?.toDouble() ?? 0.0,
      stock: stockValue,

      tags: List<String>.from((json["tags"] ?? []).map((x) => x)),

      brand: json["brand"],
      sku: json["sku"] ?? '',

      weight: json["weight"] as int? ?? 0,

      dimensions: Dimensions.fromJson(json["dimensions"] ?? {}),
      warrantyInformation: json["warrantyInformation"] ?? '',
      shippingInformation: json["shippingInformation"] ?? '',

      // FIX: Robust enum mapping with fallback
      availabilityStatus:
          availabilityKey != null &&
              availabilityStatusValues.map.containsKey(availabilityKey)
          ? availabilityStatusValues.map[availabilityKey]!
          : defaultAvailability,

      reviews: List<Review>.from(
        (json["reviews"] ?? []).map((x) => Review.fromJson(x)),
      ),

      // FIX: Robust enum mapping with fallback
      returnPolicy:
          returnPolicyKey != null &&
              returnPolicyValues.map.containsKey(returnPolicyKey)
          ? returnPolicyValues.map[returnPolicyKey]!
          : defaultReturnPolicy,

      minimumOrderQuantity: json["minimumOrderQuantity"] as int? ?? 0,

      meta: Meta.fromJson(json["meta"] ?? {}),
      images: List<String>.from((json["images"] ?? []).map((x) => x)),
      thumbnail: json["thumbnail"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": categoryValues.reverse[category],
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "brand": brand,
    "sku": sku,
    "weight": weight,
    "dimensions": dimensions.toJson(),
    "warrantyInformation": warrantyInformation,
    "shippingInformation": shippingInformation,
    "availabilityStatus": availabilityStatusValues.reverse[availabilityStatus],
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    "returnPolicy": returnPolicyValues.reverse[returnPolicy],
    "minimumOrderQuantity": minimumOrderQuantity,
    "meta": meta.toJson(),
    "images": List<dynamic>.from(images.map((x) => x)),
    "thumbnail": thumbnail,
  };
}

// ... (Helper classes remain the same) ...

enum AvailabilityStatus { IN_STOCK, LOW_STOCK }

final availabilityStatusValues = EnumValues({
  "In Stock": AvailabilityStatus.IN_STOCK,
  "Low Stock": AvailabilityStatus.LOW_STOCK,
});

enum Category { BEAUTY, FRAGRANCES, FURNITURE, GROCERIES }

final categoryValues = EnumValues({
  "beauty": Category.BEAUTY,
  "fragrances": Category.FRAGRANCES,
  "furniture": Category.FURNITURE,
  "groceries": Category.GROCERIES,
});

class Dimensions {
  double width;
  double height;
  double depth;

  Dimensions({required this.width, required this.height, required this.depth});

  factory Dimensions.fromJson(Map<String, dynamic>? json) => Dimensions(
    width: json?["width"]?.toDouble() ?? 0.0,
    height: json?["height"]?.toDouble() ?? 0.0,
    depth: json?["depth"]?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
    "depth": depth,
  };
}

class Meta {
  DateTime createdAt;
  DateTime updatedAt;
  String barcode;
  String qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic>? json) => Meta(
    createdAt: json?["createdAt"] != null
        ? DateTime.parse(json!["createdAt"])
        : DateTime.now(),
    updatedAt: json?["updatedAt"] != null
        ? DateTime.parse(json!["updatedAt"])
        : DateTime.now(),
    barcode: json?["barcode"] ?? '',
    qrCode: json?["qrCode"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "barcode": barcode,
    "qrCode": qrCode,
  };
}

enum ReturnPolicy {
  NO_RETURN_POLICY,
  THE_30_DAYS_RETURN_POLICY,
  THE_60_DAYS_RETURN_POLICY,
  THE_7_DAYS_RETURN_POLICY,
  THE_90_DAYS_RETURN_POLICY,
}

final returnPolicyValues = EnumValues({
  "No return policy": ReturnPolicy.NO_RETURN_POLICY,
  "30 days return policy": ReturnPolicy.THE_30_DAYS_RETURN_POLICY,
  "60 days return policy": ReturnPolicy.THE_60_DAYS_RETURN_POLICY,
  "7 days return policy": ReturnPolicy.THE_7_DAYS_RETURN_POLICY,
  "90 days return policy": ReturnPolicy.THE_90_DAYS_RETURN_POLICY,
});

class Review {
  int rating;
  String comment;
  DateTime date;
  String reviewerName;
  String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rating: json["rating"] as int? ?? 0,
    comment: json["comment"] ?? '',
    date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
    reviewerName: json["reviewerName"] ?? '',
    reviewerEmail: json["reviewerEmail"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "comment": comment,
    "date": date.toIso8601String(),
    "reviewerName": reviewerName,
    "reviewerEmail": reviewerEmail,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
