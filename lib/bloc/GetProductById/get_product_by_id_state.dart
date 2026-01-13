part of 'get_product_by_id_bloc.dart';

abstract class GetProductByIdState {}

final class GetProductByIdInitial extends GetProductByIdState {}

final class GetProductByIdLoading extends GetProductByIdState {}

final class GetProductByIdLoaded extends GetProductByIdState {
  final GetProductByIdModel getProductByIdModel;
  GetProductByIdLoaded({required this.getProductByIdModel});
}

final class GetProductByIdError extends GetProductByIdState {
  final String errorMessage;
  GetProductByIdError({required this.errorMessage});
}
