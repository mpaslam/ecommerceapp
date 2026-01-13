part of 'update_item_by_id_bloc.dart';

abstract class UpdateItemByIdState {}

final class UpdateItemByIdInitial extends UpdateItemByIdState {}

final class UpdateItemByIdLoading extends UpdateItemByIdState {}

final class UpdateItemByIdLoaded extends UpdateItemByIdState {
  final UpdateItemByIdModel updateItemByIdModel;
  UpdateItemByIdLoaded({required this.updateItemByIdModel});
}

final class UpdateItemByIdError extends UpdateItemByIdState {
  final String message;
  UpdateItemByIdError({required this.message});
}
