part of 'get_product_by_id_bloc.dart';

abstract class GetProductByIdEvent {}

class FetchGetProductByIdEvent extends GetProductByIdEvent {
  final String id;
  FetchGetProductByIdEvent(this.id);
}
class UpdateProductDetailsEvent extends GetProductByIdEvent {
  final GetProductByIdModel updatedModel;

  UpdateProductDetailsEvent({required this.updatedModel});
}
