part of 'get_all_product_list_bloc.dart';

abstract class GetAllProductListState {}

final class GetAllProductListInitial extends GetAllProductListState {}

final class GetAllProductListLoading extends GetAllProductListState {}

final class GetAllProductListLoaded extends GetAllProductListState {
  final GetAllProductsListModel getAllProductsListModel;
  GetAllProductListLoaded(this.getAllProductsListModel);
}

final class GetAllProductListError extends GetAllProductListState {
  final String message;
  GetAllProductListError(this.message);
}
