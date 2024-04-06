import 'package:get/get.dart';
import 'package:store/src/infrastructure/commons/params.dart';
import 'package:store/src/pages/customer/detail_product/models/customer_detail_selected_product_view_model.dart';
import '../../../../../generated/locales.g.dart';
import '../models/customer_detail_selected_product_patch_dto.dart';
import '../models/customer_detail_selected_product_post_dto.dart';
import '../repositories/customer_detail_product_repository.dart';

class CustomerDetailProductController extends GetxController {
  final int productId;

  CustomerDetailProductController({required this.productId});

  final CustomerDetailProductRepository _repository =
      CustomerDetailProductRepository();
  RxString image = ''.obs;
  RxString tittle = ''.obs;
  RxString description = ''.obs;
  RxInt price = RxInt(0);
  RxInt count = RxInt(0);
  RxInt id = RxInt(0);
  RxList<String> colors = RxList();
  RxBool isGetProductLoad = false.obs;
  RxBool isGetProductRetry = false.obs;
  RxBool isAddToShoppingCartLoad = false.obs;
  RxInt selectedCount = 1.obs;
  int changeCount = 0;
  bool isExistInSelectedProducts = false;

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }

  Future<void> getProduct() async {
    isExistInSelectedProducts = false;
    isGetProductRetry.value = false;
    isGetProductLoad.value = true;
    final result = await _repository.getSelectedProductByProductIdAndUserId(
      userId: Params.userId!,
      productId: productId,
    );
    isGetProductLoad.value = false;
    result.fold(
      (left) {
        isGetProductRetry.value = true;
        Get.showSnackbar(
          GetSnackBar(
            message: '${LocaleKeys.error.tr} : $left',
            duration: const Duration(seconds: 2),
          ),
        );
      },
      (right) async {
        if (right.isNotEmpty) {
          CustomerDetailSelectedProductViewModel product =
              CustomerDetailSelectedProductViewModel.fromJson(right[0]);
          isExistInSelectedProducts = true;
          id.value = product.id;
          image.value = product.image ?? '';
          tittle.value = product.tittle;
          description.value = product.description ?? '';
          price.value = product.price;
          count.value = product.count;
          colors.addAll(product.colors);
          selectedCount.value = product.selectedCount;
          changeCount = product.selectedCount;
        } else {
          isGetProductRetry.value = false;
          isGetProductLoad.value = true;
          final result = await _repository.getProductById(id: productId);
          isGetProductLoad.value = false;
          result.fold(
            (left) {
              isGetProductRetry.value = true;
              Get.showSnackbar(
                GetSnackBar(
                  message: '${LocaleKeys.error.tr} : $left',
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            (right) {
              image.value = right.image ?? '';
              tittle.value = right.tittle;
              description.value = right.description ?? '';
              price.value = right.price;
              count.value = right.count;
              colors.addAll(right.colors.cast<String>());
            },
          );
        }
      },
    );
  }

  void onIncreaseTap(int newValue) {
    selectedCount.value = newValue;
  }

  void onDecreaseTap(int newValue) {
    selectedCount.value = newValue;
  }

  Future<void> onAddToCartTap() async {
    if (isExistInSelectedProducts) {
      final CustomerDetailSelectedProductPatchDto dto =
          CustomerDetailSelectedProductPatchDto(
        image.value,
        description.value,
        colors,
        id: id.value,
        userId: Params.userId!,
        productId: productId,
        tittle: tittle.value,
        price: price.value,
        count: count.value,
        selectedCount: selectedCount.value,
      );
      isAddToShoppingCartLoad.value = true;
      final result = await _repository.patchSelectedProduct(dto: dto);
      isAddToShoppingCartLoad.value = false;
      result.fold((left) {
        Get.showSnackbar(GetSnackBar(
          message: '${LocaleKeys.error.tr} : $left',
          duration: const Duration(seconds: 2),
        ));
      }, (right) {
        changeCount = selectedCount.value - changeCount;
        Get.back(result: changeCount);
      });
    } else {
      final CustomerDetailSelectedProductPostDto dto =
          CustomerDetailSelectedProductPostDto(
        image.value,
        description.value,
        colors,
        userId: Params.userId!,
        productId: productId,
        tittle: tittle.value,
        price: price.value,
        count: count.value,
        selectedCount: selectedCount.value,
      );
      isAddToShoppingCartLoad.value = true;
      final result = await _repository.postSelectedProduct(dto: dto);
      isAddToShoppingCartLoad.value = false;
      result.fold((left) {
        Get.showSnackbar(GetSnackBar(
          message: '${LocaleKeys.error.tr} : $left',
          duration: const Duration(seconds: 2),
        ));
      }, (right) {
        changeCount = selectedCount.value - changeCount;
        Get.back(result: changeCount);
      });
    }
  }
}
