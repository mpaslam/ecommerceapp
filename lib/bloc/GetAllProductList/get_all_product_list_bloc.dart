import 'package:bloc/bloc.dart';
import 'package:ecommerceapp/Repository/Api/GetAllProductList/get_all_product_list_api.dart';
import 'package:ecommerceapp/Repository/Model/get_all_product_list_model.dart';
import 'package:flutter/foundation.dart';
part 'get_all_product_list_event.dart';
part 'get_all_product_list_state.dart';

class GetAllProductListBloc
    extends Bloc<GetAllProductListEvent, GetAllProductListState> {
  late GetAllProductsListModel getAllProductListModel;
  GetAllProductListApi getAllProductListApi = GetAllProductListApi();

  GetAllProductListBloc() : super(GetAllProductListInitial()) {
    on<FetchGetAllProductListEvent>((event, emit) async {
      emit(GetAllProductListLoading());
      try {
        getAllProductListModel = await getAllProductListApi.postuserdata();
        emit(GetAllProductListLoaded(getAllProductListModel));
      } catch (e) {
        debugPrint("erorrrmmrrrrr ${e.toString()}");

        emit(GetAllProductListError(e.toString()));
      }
    });
  }
}
