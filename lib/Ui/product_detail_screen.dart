import 'package:ecommerceapp/Ui/product_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/Repository/Model/get_product_by_id_model.dart';
import 'package:ecommerceapp/Repository/Model/get_all_product_list_model.dart'
    as all_products_model;
import 'package:ecommerceapp/bloc/GetProductById/get_product_by_id_bloc.dart';
import 'package:ecommerceapp/bloc/UpdateItemById/update_item_by_id_bloc.dart';
import 'package:ecommerceapp/utils/app_colors.dart';
import 'package:ecommerceapp/utils/app_text_styles.dart';

class ProductDetailScreen extends StatefulWidget {
  final all_products_model.Product product;

  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isEditing = false;
  bool _isDataFetched = false;
  late GetProductByIdModel _editableProductDetails;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GetProductByIdBloc>().add(
      FetchGetProductByIdEvent(widget.product.id.toString()),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditMode(GetProductByIdModel productDetails) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _titleController.text = productDetails.title;
        _priceController.text = productDetails.price.toStringAsFixed(2);
        _descriptionController.text = productDetails.description;
      }
    });
  }

  void _saveChanges() {
    if (!_isEditing) return;

    final double newPrice =
        double.tryParse(_priceController.text) ?? _editableProductDetails.price;

    context.read<UpdateItemByIdBloc>().add(
      FetchUpdateItemByIdEvent(
        id: _editableProductDetails.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: newPrice,
        discountPercentage: _editableProductDetails.discountPercentage,
        rating: _editableProductDetails.rating,
        stock: _editableProductDetails.stock,
        brand: _editableProductDetails.brand ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpdateItemByIdBloc, UpdateItemByIdState>(
            listener: (context, state) {
              if (state is UpdateItemByIdLoaded) {
                _editableProductDetails = GetProductByIdModel.fromJson(
                  state.updateItemByIdModel.toJson(),
                );

                _titleController.text = _editableProductDetails.title;
                _priceController.text = _editableProductDetails.price
                    .toStringAsFixed(2);
                _descriptionController.text =
                    _editableProductDetails.description;

                setState(() {
                  _isEditing = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product updated successfully!'),
                  ),
                );
              } else if (state is UpdateItemByIdError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed: ${state.message}')),
                );
              }
            },
          ),
        ],
        child: Stack(
          children: [
            BlocBuilder<GetProductByIdBloc, GetProductByIdState>(
              builder: (context, state) {
                if (state is GetProductByIdLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProductByIdLoaded) {
                  final GetProductByIdModel loadedProductDetails =
                      state.getProductByIdModel;

                  if (!_isDataFetched) {
                    _editableProductDetails = loadedProductDetails;
                    _isDataFetched = true;
                  }

                  final GetProductByIdModel productDetails =
                      _editableProductDetails;

                  return ProductDetailContent(
                    productDetails: productDetails,
                    screenWidth: screenWidth,
                    isEditing: _isEditing,
                    onToggleEditMode: () => _toggleEditMode(productDetails),
                    titleController: _titleController,
                    priceController: _priceController,
                    descriptionController: _descriptionController,
                    buildAppBar: _buildAppBar,
                    buildBottomButton: _buildBottomButton,
                    buildDeliveryCard: _buildDeliveryCard,
                  );
                } else if (state is GetProductByIdError) {
                  return Center(child: Text(state.errorMessage));
                }
                return Center(child: Text('Product ID: ${widget.product.id}'));
              },
            ),
            BlocBuilder<UpdateItemByIdBloc, UpdateItemByIdState>(
              builder: (context, updateState) {
                if (updateState is UpdateItemByIdLoading) {
                  return _buildLoadingOverlay();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.white),
            const SizedBox(height: 15),
            Text(
              'Saving Changes...',
              style: AppTextStyles.prominentLabel(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    double iconSize,
    GetProductByIdModel productDetails,
  ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: iconSize * 0.3,
          vertical: iconSize * 0.2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(iconSize * 0.25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.08),
                    blurRadius: iconSize * 0.16,
                    offset: Offset(0, iconSize * 0.04),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: iconSize * 0.375),
                onPressed: () {
                  if (_isEditing) {
                    setState(() => _isEditing = false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                padding: EdgeInsets.zero,
              ),
            ),
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(iconSize * 0.25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.08),
                    blurRadius: iconSize * 0.16,
                    offset: Offset(0, iconSize * 0.04),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _isEditing ? Icons.close : Icons.favorite_border,
                  size: iconSize * 0.45,
                ),
                onPressed: () =>
                    _isEditing ? setState(() => _isEditing = false) : (null),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(double screenWidth) {
    final double cardPadding = screenWidth * 0.04;
    final double logoSize = screenWidth * 0.15;
    final double nameFontSize = screenWidth * 0.04;
    final double statusFontSize = screenWidth * 0.0325;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: screenWidth * 0.05,
            offset: Offset(0, screenWidth * 0.01),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            alignment: Alignment.center,
            child: Text(
              'Jam',
              style: AppTextStyles.prominentLabel(
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
          SizedBox(width: cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aghmashenebeli Ave 75',
                  style: AppTextStyles.prominentLabel(
                    fontSize: nameFontSize,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  '1 Item is in the way',
                  style: AppTextStyles.description(
                    fontSize: statusFontSize,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: screenWidth * 0.045,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(double screenWidth) {
    final double buttonHeight = screenWidth * 0.16;
    final double buttonTextSize = screenWidth * 0.04;
    final String buttonText = _isEditing ? 'SAVE CHANGES' : 'ADD TO CART';
    final IconData buttonIcon = _isEditing
        ? Icons.save
        : Icons.shopping_cart_outlined;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.06,
          screenWidth * 0.05,
          screenWidth * 0.06,
          screenWidth * 0.08,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(screenWidth * 0.08),
            topRight: Radius.circular(screenWidth * 0.08),
          ),
        ),
        child: Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            color: AppColors.darkPurple,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkPurple.withOpacity(0.4),
                blurRadius: screenWidth * 0.05,
                offset: Offset(0, screenWidth * 0.02),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: _isEditing ? _saveChanges : () {},
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      buttonIcon,
                      color: AppColors.white,
                      size: screenWidth * 0.06,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      buttonText,
                      style: AppTextStyles.buttonText(fontSize: buttonTextSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
