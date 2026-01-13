import 'package:bloc/bloc.dart';
import 'package:ecommerceapp/Repository/Api/UpdateItemById/update_item_by_id_api.dart';
import 'package:ecommerceapp/Repository/Model/update_item_by_id_model.dart';
import 'package:flutter/foundation.dart';

part 'update_item_by_id_event.dart';
part 'update_item_by_id_state.dart';

class UpdateItemByIdBloc
    extends Bloc<UpdateItemByIdEvent, UpdateItemByIdState> {
  late UpdateItemByIdModel updateItemByIdModel;
  UpdateItemByIdApi updateItemByIdApi = UpdateItemByIdApi();

  UpdateItemByIdBloc() : super(UpdateItemByIdInitial()) {
    on<FetchUpdateItemByIdEvent>((event, emit) async {
      emit(UpdateItemByIdLoading());
      try {
        updateItemByIdModel = await updateItemByIdApi.postuserdata(
          id: event.id.toString(),
          idInt: event.id,
          title: event.title,
          description: event.description,
          price: event.price,
          discountPercentage: event.discountPercentage,
          rating: event.rating,
          stock: event.stock,
          brand: event.brand,
        );
        emit(UpdateItemByIdLoaded(updateItemByIdModel: updateItemByIdModel));
      } catch (e) {
        debugPrint("Update error: ${e.toString()}");
        emit(UpdateItemByIdError(message: e.toString()));
      }
    });
  }
}
