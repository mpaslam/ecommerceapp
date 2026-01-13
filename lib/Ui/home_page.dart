import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/Ui/product_detail_screen.dart';
import 'package:ecommerceapp/Repository/Model/get_all_product_list_model.dart';
import 'package:ecommerceapp/bloc/GetAllProductList/get_all_product_list_bloc.dart';
// ADD UTILITY IMPORTS HERE
import 'package:ecommerceapp/utils/app_colors.dart';
import 'package:ecommerceapp/utils/app_text_styles.dart';


class ShowAllProductsScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Product> products;

  const ShowAllProductsScreen({
    required this.categoryTitle,
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth * 0.45;
    final double spacing = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: GridView.builder(
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: itemWidth / (itemWidth * 1.6),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.425;
    final double imageSize = screenWidth * 0.30;
    final double baseFontSize = screenWidth * 0.04;
    final double smallFontSize = screenWidth * 0.03;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.025),
      decoration: BoxDecoration(
        color: AppColors.white, // REPLACED
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05), // REPLACED (Color.fromRGBO)
            offset: Offset(0, screenWidth * 0.0075),
            blurRadius: screenWidth * 0.025,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: imageSize,
                alignment: Alignment.center,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.broken_image, size: imageSize * 0.5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: const BoxDecoration(
                  color: AppColors.white, // REPLACED
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: baseFontSize,
                  color: AppColors.black, // REPLACED
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.025),
          Text(
            product.title,
            style: AppTextStyles.boldTitle( // REPLACED
              fontSize: baseFontSize,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: screenWidth * 0.0125),
          SizedBox(
            height: screenWidth * 0.125,
            child: Text(
              product.description,
              style: AppTextStyles.description( // REPLACED
                fontSize: smallFontSize,
                color: AppColors.grey,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Text(
            '\$ ${product.price.toStringAsFixed(2)}',
            style: AppTextStyles.productCardPriceText( // REPLACED
              fontSize: baseFontSize * 1.125,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListSection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductListSection({
    required this.title,
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal = screenWidth * 0.05;
    final double titleFontSize = screenWidth * 0.055;
    final double buttonFontSize = screenWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.boldTitle( // REPLACED
                  fontSize: titleFontSize,
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllProductsScreen(
                        categoryTitle: title,
                        products: products,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Show All',
                  style: AppTextStyles.description( // REPLACED
                    color: AppColors.blue, // REPLACED
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth * 0.0375),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: paddingHorizontal),
          child: Row(
            children: products
                .map(
                  (product) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: ProductCard(product: product),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      context.read<GetAllProductListBloc>().add(FetchGetAllProductListEvent());
      _isDataFetched = true;
    }
  }

  List<Product> _filterProducts(
      List<Product> allProducts, String categoryKeyword) {
    final lowerCaseKeyword = categoryKeyword.toLowerCase();

    return allProducts.where((p) {
      final categoryString = categoryValues.reverse[p.category];
      final categoryMatch = categoryString != null &&
          categoryString.toLowerCase().contains(lowerCaseKeyword);
      final titleMatch = p.title.toLowerCase().contains(lowerCaseKeyword);
      return categoryMatch || titleMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal = screenWidth * 0.05;
    final double largeTitleFontSize = screenWidth * 0.085;
    final double subTitleFontSize = screenWidth * 0.04;
    final double spacingLarge = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: AppColors.white, // REPLACED
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenWidth * 0.025,
                  left: paddingHorizontal,
                  right: paddingHorizontal,
                  bottom: screenWidth * 0.05,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, size: 30),
                    Icon(Icons.shopping_cart_outlined, size: 30),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover our exclusive\nproducts',
                      style: AppTextStyles.boldTitle( // REPLACED
                        fontSize: largeTitleFontSize,
                        fontWeight: FontWeight.w900, // Explicitly keep w900 for this header
                        height: 1.1,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.025),
                    Text(
                      'In this marketplace, you will find various\ntechnics in the cheapest price',
                      style: AppTextStyles.description( // REPLACED
                        fontSize: subTitleFontSize,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacingLarge),
              // ... (BlocBuilder content remains the same) ...
              BlocBuilder<GetAllProductListBloc, GetAllProductListState>(
                builder: (context, state) {
                  if (state is GetAllProductListLoading) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.2,
                        ),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is GetAllProductListLoaded) {
                    // ... (list filtering logic) ...
                    final allProducts = state.getAllProductsListModel.products;

                    final headphonesList = _filterProducts(
                      allProducts,
                      'fragrances',
                    );
                    final mobilesAccessoriesList = _filterProducts(
                      allProducts,
                      'beauty',
                    );

                    return Column(
                      children: [
                        ProductListSection(
                          title: 'Headphones',
                          products: headphonesList,
                        ),
                        SizedBox(height: spacingLarge),
                        ProductListSection(
                          title: 'Mobiles & accessories',
                          products: mobilesAccessoriesList,
                        ),
                        SizedBox(height: spacingLarge),
                      ],
                    );
                  } else if (state is GetAllProductListError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.075),
                        child: Text(
                          'Failed to load products: ${state.message}',
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}