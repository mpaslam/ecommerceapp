part of 'update_item_by_id_bloc.dart';

@immutable
abstract class UpdateItemByIdEvent {}

class FetchUpdateItemByIdEvent extends UpdateItemByIdEvent {
  final int id; 
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  

  FetchUpdateItemByIdEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
  });
}