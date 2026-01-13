import 'package:flutter/material.dart';
import 'package:ecommerceapp/Repository/Model/get_product_by_id_model.dart';
import 'package:ecommerceapp/utils/app_colors.dart';
import 'package:ecommerceapp/utils/app_text_styles.dart';

typedef AppBarBuilder =
    Widget Function(
      BuildContext context,
      double iconSize,
      GetProductByIdModel productDetails,
    );
typedef BottomButtonBuilder = Widget Function(double screenWidth);
typedef DeliveryCardBuilder = Widget Function(double screenWidth);

class ProductDetailContent extends StatelessWidget {
  final GetProductByIdModel productDetails;
  final double screenWidth;
  final bool isEditing;
  final VoidCallback onToggleEditMode;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final AppBarBuilder buildAppBar;
  final BottomButtonBuilder buildBottomButton;
  final DeliveryCardBuilder buildDeliveryCard;

  const ProductDetailContent({
    required this.productDetails,
    required this.screenWidth,
    required this.isEditing,
    required this.onToggleEditMode,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.buildAppBar,
    required this.buildBottomButton,
    required this.buildDeliveryCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double appBarIconSize = screenWidth * 0.12;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: screenWidth * 0.25),
          child: Column(
            children: [_buildTopSection(context), _buildContentSection()],
          ),
        ),
        buildAppBar(context, appBarIconSize, productDetails),
        buildBottomButton(screenWidth),
      ],
    );
  }

  Widget _buildTopSection(BuildContext context) {
    final double topPadding = screenWidth * 0.25;
    final double bottomPadding = screenWidth * 0.1;
    final double imageContainerSize = screenWidth * 0.7;
    final double imageSize = screenWidth * 0.55;
    final double priceFontSize = screenWidth * 0.09;
    final double editIconSize = screenWidth * 0.15;
    final double editIconBgSize = screenWidth * 0.125;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(screenWidth * 0.1),
          bottomRight: Radius.circular(screenWidth * 0.1),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: imageContainerSize,
                height: imageContainerSize,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.network(
                    productDetails.thumbnail,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.06),
              isEditing
                  ? Container(
                      width: screenWidth * 0.4,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.priceText(
                          fontSize: priceFontSize,
                          color: AppColors.accentBlue,
                        ),
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          prefixStyle: AppTextStyles.priceText(
                            fontSize: priceFontSize,
                            color: AppColors.accentBlue,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accentBlue),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      '\$ ${productDetails.price.toStringAsFixed(2)}',
                      style: AppTextStyles.priceText(
                        fontSize: priceFontSize,
                        color: AppColors.accentBlue,
                      ),
                    ),
            ],
          ),
          Positioned(
            right: screenWidth * 0.05,
            top: screenWidth * 0.2,
            child: GestureDetector(
              onTap: onToggleEditMode,
              child: Container(
                width: editIconBgSize,
                height: editIconBgSize,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkPurple.withOpacity(0.2),
                      blurRadius: screenWidth * 0.03,
                      offset: Offset(0, screenWidth * 0.015),
                    ),
                  ],
                ),
                child: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: AppColors.darkPurple,
                  size: editIconSize * 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    final double padding = screenWidth * 0.06;
    final double titleFontSize = screenWidth * 0.075;
    final double subtitleFontSize = screenWidth * 0.035;
    final double descriptionFontSize = screenWidth * 0.0375;
    final double tabPaddingVertical = screenWidth * 0.03;
    final double tabPaddingHorizontal = screenWidth * 0.06;

    final Widget titleWidget = isEditing
        ? TextFormField(
            controller: titleController,
            style: AppTextStyles.boldTitle(
              fontSize: titleFontSize,
              height: 1.1,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          )
        : Text(
            productDetails.title,
            style: AppTextStyles.boldTitle(
              fontSize: titleFontSize,
              height: 1.1,
            ),
          );

    final Widget descriptionWidget = isEditing
        ? TextFormField(
            controller: descriptionController,
            maxLines: 5,
            minLines: 3,
            style: AppTextStyles.description(
              fontSize: descriptionFontSize,
              height: 1.6,
              color: AppColors.black87,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
          )
        : Text(
            productDetails.description,
            style: AppTextStyles.description(
              fontSize: descriptionFontSize,
              height: 1.6,
              color: AppColors.black87,
            ),
          );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.1),
          topRight: Radius.circular(screenWidth * 0.1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              if (!isEditing) // CONDITIONALLY SHOW BEST SELLER
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                    vertical: screenWidth * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bestSellerPink,
                    borderRadius: BorderRadius.circular(screenWidth * 0.015),
                  ),
                  child: Text(
                    'Best Seller',
                    style: AppTextStyles.prominentLabel(
                      fontSize: screenWidth * 0.0275,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),

          _buildRatingAndStockInfo(subtitleFontSize),
          _buildCategoryInfo(subtitleFontSize),
          SizedBox(height: screenWidth * 0.06),

          Text(
            'About the item',
            style: AppTextStyles.description(
              fontSize: subtitleFontSize,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          if (!isEditing)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tabPaddingHorizontal,
                    vertical: tabPaddingVertical,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lavender.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Text(
                    'Full Specification',
                    style: AppTextStyles.prominentLabel(
                      fontSize: descriptionFontSize,
                      color: AppColors.black87,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.06),
                Text(
                  'Reviews',
                  style: AppTextStyles.description(
                    fontSize: descriptionFontSize,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          SizedBox(height: screenWidth * 0.06),
          descriptionWidget,
          SizedBox(height: screenWidth * 0.07),
          buildDeliveryCard(screenWidth),
        ],
      ),
    );
  }

  Widget _buildRatingAndStockInfo(double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              SizedBox(width: screenWidth * 0.01),
              Text(
                productDetails.rating.toStringAsFixed(2),
                style: AppTextStyles.description(
                  fontSize: fontSize,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' / 5.0',
                style: AppTextStyles.description(
                  fontSize: fontSize,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Text(
            'Stock: ${productDetails.stock}',
            style: AppTextStyles.description(
              fontSize: fontSize,
              color: productDetails.stock > 10
                  ? AppColors.darkPurple
                  : AppColors.bestSellerPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo(double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: Row(
        children: [
          Text(
            'Category: ',
            style: AppTextStyles.description(
              fontSize: fontSize,
              color: AppColors.grey,
            ),
          ),
          Text(
            productDetails.category.name.toUpperCase(),
            style: AppTextStyles.description(
              fontSize: fontSize,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}