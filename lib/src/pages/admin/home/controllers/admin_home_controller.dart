import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../infrastructure/commons/params.dart';
import '../../../../infrastructure/route/route_names.dart';
import '../models/admin_home_dto.dart';
import '../../../../../generated/locales.g.dart';
import '../models/admin_home_view_model.dart';
import '../repositories/admin_home_repository.dart';

class AdminHomeController extends GetxController {
  final AdminHomeRepository _repository = AdminHomeRepository();
  final SharedPreferences _preferences = Get.find<SharedPreferences>();
  final RxList<AdminHomeViewModel> products = RxList();
  RxBool isGetProductsLoading = false.obs;
  RxBool isGetProductsRetry = false.obs;
  RxBool isActiveDisable = false.obs;
  Rx<RangeValues> rangeSliderValues = const RangeValues(0, 0).obs;
  RxInt maxPrice = RxInt(0);
  RxInt minPrice = RxInt(0);
  int maxFilter = 0;
  int minFilter = 0;
  RxSet<String> filterColorsList = RxSet();
  RxInt filterColorIndex = RxInt(-1);
  String filterColor = '';
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getProducts(
      searchText: searchTextController.text,
    );
    getMaxAndMinPriceAndFilterColors();
  }

  Future<void> getProducts({required String searchText}) async {
    isGetProductsRetry.value = false;
    isGetProductsLoading.value = true;
    final result = await _repository.getProducts(
      sellerId: Params.userId!,
      minPrice: minFilter,
      maxPrice: maxFilter,
      search: searchText,
      color: filterColor,
    );
    isGetProductsLoading.value = false;
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

  Future<void> getMaxAndMinPriceAndFilterColors() async {
    final result = await _repository.getProductsBySortPrice(sellerId: Params.userId!);
    result.fold((left) {
      Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
        duration: const Duration(seconds: 2),
      ));
    }, (right) {
      if (right.isNotEmpty) {
        for(final product in right){
          filterColorsList.addAll(product.colors);
        }
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

  Future<void> onAddPressed() async {
    final result = await Get.toNamed(
        RouteNames.adminHomePage + RouteNames.adminAddProductPage);
    if (result != null) {
      final AdminHomeViewModel product = AdminHomeViewModel.fromJson(result);
      products.add(product);
      getMaxAndMinPriceAndFilterColors();
    }
  }

  void onFilterColorTap(int index){
    filterColorIndex.value = index;
  }

  void onLogoutPressed() {
    Params.userId = null;
    Params.isAdmin = null;
    _preferences.clear();
    Get.offAllNamed(RouteNames.loginPage);
  }

  Future<void> onActiveSwitchTap(newValue, AdminHomeViewModel product) async {
    AdminHomeDto dto = AdminHomeDto(
      product.image,
      product.description,
      product.colors,
      id: product.id,
      tittle: product.tittle,
      price: product.price,
      sellerId: Params.userId!,
      count: product.count,
      isActive: newValue,
    );
    isActiveDisable.value = true;
    final result = await _repository.patchProduct(dto: dto);
    isActiveDisable.value = false;
    result.fold(
        (left) => Get.showSnackbar(GetSnackBar(
              message: '${LocaleKeys.error.tr} : $left',
              duration: const Duration(seconds: 2),
            )), (right) {
      int index = products.indexWhere((element) => element.id == right.id);
      products[index] = right;
    });
  }

  void updateAppLanguage({required Locale locale}) => Get.updateLocale(locale);

  void rangePriceOnChange(newValues) {
    rangeSliderValues.value = newValues;
  }

  Future<void> onEditIconTap(int id) async {
    final result = await Get.toNamed(
        RouteNames.adminHomePage + RouteNames.adminEditProductPage,
        parameters: {'id': id.toString()});

    if (result != null) {
      AdminHomeViewModel product = AdminHomeViewModel.fromJson(result);
      int index = products.indexWhere((element) => element.id == product.id);
      products[index] = product;
      getMaxAndMinPriceAndFilterColors();
    }
  }

  Future<void> onFilterPressed() async {
    maxFilter = rangeSliderValues.value.end.round();
    minFilter = rangeSliderValues.value.start.round();
    if(filterColorIndex.value != -1){
      filterColor = filterColorsList.toList()[filterColorIndex.value];
    }
    getProducts(
      searchText: searchTextController.text,
    );
  }

  Future<void> onRemoveFilterPressed() async {
    maxFilter = 0;
    minFilter = 0;
    filterColor = '';
    filterColorIndex.value = -1;
    getProducts(
      searchText: searchTextController.text,
    );
  }

  Future<void> onSearchTextChange(String value) async {
    getProducts(
      searchText: value,
    );
  }
}
