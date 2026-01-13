import 'package:ecommerceapp/Ui/home_page.dart';
import 'package:ecommerceapp/bloc/GetAllProductList/get_all_product_list_bloc.dart';
import 'package:ecommerceapp/bloc/GetProductById/get_product_by_id_bloc.dart';
import 'package:ecommerceapp/bloc/UpdateItemById/update_item_by_id_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String basePath = "https://dummyjson.com/";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetAllProductListBloc()),
        BlocProvider(create: (context) => GetProductByIdBloc()),
        BlocProvider(create: (context) => UpdateItemByIdBloc()),
      ],
      child: const MaterialApp(
        title: 'E-commerce UI',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
