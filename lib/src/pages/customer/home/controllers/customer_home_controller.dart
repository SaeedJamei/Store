import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/src/infrastructure/commons/params.dart';
import '../../../../../generated/locales.g.dart';
import '../../../../infrastructure/route/route_names.dart';
import '../models/customer_home_product_view_model.dart';
import '../repositories/customer_home_repository.dart';

class CustomerHomeController extends GetxController {


  final CustomerHomeRepository _repository = CustomerHomeRepository();
  final SharedPreferences _preferences = Get.find<SharedPreferences>();
  RxList<CustomerHomeProductViewModel> products = RxList();
  RxBool isGetProductsLoading = false.obs;
  RxBool isGetProductsRetry = false.obs;
  Rx<RangeValues> rangeSliderValues = const RangeValues(0, 0).obs;
  RxInt maxPrice = RxInt(0);
  RxInt minPrice = RxInt(0);
  int maxFilter = 0;
  int minFilter = 0;
  RxInt allProductsSelectedCount = RxInt(0);
  final TextEditingController searchTextController = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    getProducts(
      searchText: searchTextController.text,
    );
    getAllProductsSelectedCount();
    getMaxAndMinPrice();
  }

  Future<void> getProducts({required String searchText}) async {
    isGetProductsLoading.value = true;
    final result = await _repository.getProducts(
      minPrice: minFilter,
      maxPrice: maxFilter,
      search: searchText,
    );
    isGetProductsLoading.value = false;
    isGetProductsRetry.value = false;
    result.fold((left) {
      isGetProductsRetry.value = true;
      Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
        duration: const Duration(seconds: 2),
      ));
    }, (right) {
      products.clear();
      products.addAll(right);
    });
  }

  Future<void> getMaxAndMinPrice() async {
    final result = await _repository.getProductsBySortPrice();
    result.fold((left) {
      Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
      ));
    }, (right) {
      if(right.isNotEmpty){
        minPrice.value = right[0].price;
        maxPrice.value = right[(right.length - 1)].price;
      }
      if (maxPrice.value == minPrice.value) {
        maxPrice.value = maxPrice.value + 1;
      }
      rangeSliderValues.value =
          RangeValues(minPrice.value.toDouble(), maxPrice.value.toDouble());
    });
  }

  Future<void> getAllProductsSelectedCount() async {
    final result = await _repository.getSelectedProducts(userId: Params.userId!);
    result.fold(
        (left) => Get.showSnackbar(
              GetSnackBar(
                message: '${LocaleKeys.error.tr} : $left',
                duration: const Duration(seconds: 2),
              ),
            ), (right) {
      allProductsSelectedCount.value = 0;
      for (final product in right) {
        allProductsSelectedCount.value =
            allProductsSelectedCount.value + product.selectedCount;
      }
    });
  }

  void rangePriceOnChange(newValues) {
    rangeSliderValues.value = newValues;
  }

  Future<void> onLogoutPressed() async {
    Params.userId = null;
    Params.isAdmin = null;
    _preferences.clear();
    Get.offAllNamed(RouteNames.loginPage);
  }

  void onProductTap(int id) async {
    final result = await Get.toNamed(
      RouteNames.customerHomePage + RouteNames.customerDetailProductPage,
      parameters: {'productId': id.toString()},
    );
    if(result != null){
      allProductsSelectedCount.value = allProductsSelectedCount.value + result as int;
    }
  }

  void onFilterPressed() {
    maxFilter = rangeSliderValues.value.end.round();
    minFilter = rangeSliderValues.value.start.round();
    getProducts(
      searchText: searchTextController.text,
    );
  }

  void onRemoveFilterPressed() {
    maxFilter = 0;
    minFilter = 0;
    getProducts(
      searchText: searchTextController.text,
    );
  }

  void onSearchTextChange(String value) {
    getProducts(
      searchText: value,
    );
  }

  void updateAppLanguage({required Locale locale}) => Get.updateLocale(locale);

  Future<void> onShoppingCartPressed() async {
    await Get.toNamed(
        RouteNames.customerHomePage + RouteNames.customerShoppingCartPage,);
    getProducts(searchText: searchTextController.text);
    getAllProductsSelectedCount();
  }
}
