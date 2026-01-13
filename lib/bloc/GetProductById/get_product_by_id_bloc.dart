import 'package:bloc/bloc.dart';
import 'package:ecommerceapp/Repository/Api/GetProductById/get_product_by_id_api.dart';
import 'package:ecommerceapp/Repository/Model/get_product_by_id_model.dart';
import 'package:flutter/foundation.dart';

part 'get_product_by_id_event.dart';
part 'get_product_by_id_state.dart';

class GetProductByIdBloc
    extends Bloc<GetProductByIdEvent, GetProductByIdState> {
  late GetProductByIdModel getProductByIdModel;
  GetProductByIdApi getProductByIdApi = GetProductByIdApi();

  GetProductByIdBloc() : super(GetProductByIdInitial()) {
    on<FetchGetProductByIdEvent>((event, emit) async {
      emit(GetProductByIdLoading());
      try {
        getProductByIdModel = await getProductByIdApi.postuserdata(
          id: event.id,
        );

        emit(GetProductByIdLoaded(getProductByIdModel: getProductByIdModel));
      } catch (e) {
        debugPrint("errorrkrkrkrrrr ${e.toString()}");
        emit(GetProductByIdError(errorMessage: e.toString()));
      }
    });

    on<UpdateProductDetailsEvent>((event, emit) {
      getProductByIdModel = event.updatedModel;
      emit(GetProductByIdLoaded(getProductByIdModel: event.updatedModel));
    });
  }
}
