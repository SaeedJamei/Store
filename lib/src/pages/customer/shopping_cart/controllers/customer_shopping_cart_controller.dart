import 'package:get/get.dart';
import 'package:store/src/infrastructure/commons/params.dart';
import 'package:store/src/pages/customer/shopping_cart/models/customer_shopping_cart_selected_product_dto.dart';
import '../models/customer_shopping_cart_product_dto.dart';
import '../models/customer_shopping_cart_selected_product_view_model.dart';
import '../repositories/customer_shopping_cart_repository.dart';
import '../../../../../generated/locales.g.dart';

class CustomerShoppingCartController extends GetxController {
  final CustomerShoppingCartRepository _repository =
      CustomerShoppingCartRepository();
  RxList<CustomerShoppingCartSelectedProductViewModel> selectedProducts = RxList();
  RxBool isGetProductsLoading = false.obs;
  RxBool isGetProductsRetry = false.obs;
  RxBool isDisable = false.obs;
  RxBool isPaymentLoading = false.obs;
  RxInt allTotalPrice = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getSelectedProductsByUserId();
  }

  Future<void> getSelectedProductsByUserId() async {
    isGetProductsLoading.value = true;
    final result =
        await _repository.getSelectedProductsByUserId(userId: Params.userId!);
    isGetProductsLoading.value = false;
    isGetProductsRetry.value = false;
    result.fold((left) {
      isGetProductsRetry.value = true;
      Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
        duration: const Duration(seconds: 2),
      ));
    }, (right) {
      selectedProducts.addAll(right);
      for (final product in right) {
        allTotalPrice.value =
            allTotalPrice.value + (product.selectedCount * product.price);
      }
    });
  }

  Future<void> onIncreaseTap(int newValue,
      CustomerShoppingCartSelectedProductViewModel product, int index) async {
    CustomerShoppingCartSelectedProductDto dto =
        CustomerShoppingCartSelectedProductDto(
      product.image,
      product.description,
      product.colors,
      id: product.id,
      userId: product.userId,
      productId: product.productId,
      tittle: product.tittle,
      price: product.price,
      count: product.count,
      selectedCount: newValue,
    );
    isDisable.value = true;
    final result = await _repository.patchSelectedProduct(dto: dto);
    isDisable.value = false;
    result.fold(
      (left) => Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
        duration: const Duration(seconds: 2),
      )),
      (right) {
        allTotalPrice.value = allTotalPrice.value + product.price;
        selectedProducts[index] =
            CustomerShoppingCartSelectedProductViewModel.fromJson(right);
      },
    );
  }

  Future<void> onDecreaseTap(int newValue,
      CustomerShoppingCartSelectedProductViewModel product, int index) async {
    CustomerShoppingCartSelectedProductDto dto =
        CustomerShoppingCartSelectedProductDto(
      product.image,
      product.description,
      product.colors,
      id: product.id,
      userId: product.userId,
      productId: product.productId,
      tittle: product.tittle,
      price: product.price,
      count: product.count,
      selectedCount: newValue,
    );
    isDisable.value = true;
    final result = await _repository.patchSelectedProduct(dto: dto);
    isDisable.value = false;
    result.fold(
        (left) => Get.showSnackbar(GetSnackBar(
              message: '${LocaleKeys.error.tr} : $left',
              duration: const Duration(seconds: 2),
            )), (right) {
      allTotalPrice.value = allTotalPrice.value - product.price;
      selectedProducts[index] =
          CustomerShoppingCartSelectedProductViewModel.fromJson(right);
    });
  }

  Future<void> onDeleteTap(
      {required CustomerShoppingCartSelectedProductViewModel product}) async {
    isDisable.value = true;
    final result = await _repository.deleteSelectedProduct(id: product.id);
    isDisable.value = false;
    result.fold(
        (left) => Get.showSnackbar(
              GetSnackBar(
                message: '${LocaleKeys.error.tr} : $left',
                duration: const Duration(seconds: 2),
              ),
            ), (right) {
      allTotalPrice.value = 0;
      selectedProducts.clear();
      getSelectedProductsByUserId();
    });
  }

  Future<void> onPaymentPressed() async {
    List<CustomerShoppingCartProductDto> dtoList = [];
    for (final product in selectedProducts) {
      isPaymentLoading.value = true;
      final result1 = await _repository.getProducts(id: product.productId);
      isPaymentLoading.value = false;
      result1.fold(
          (left) => Get.showSnackbar(
                GetSnackBar(
                  message: '${LocaleKeys.error.tr} : $left',
                  duration: const Duration(seconds: 2),
                ),
              ), (right) async {
        final CustomerShoppingCartProductDto dto =
            CustomerShoppingCartProductDto(
          right.image,
          right.description,
          right.colors,
          id: right.id,
          tittle: right.tittle,
          price: right.price,
          count: (right.count - product.selectedCount),
        );
        dtoList.add(dto);
      });
    }
    if (dtoList.length == selectedProducts.length) {
      await patchToProductsAndRemoveFromSelectedProducts(dtoList);
    } else {
      await onPaymentPressed();
    }
  }

  Future<void> patchToProductsAndRemoveFromSelectedProducts(
      List<CustomerShoppingCartProductDto> dtoList) async {
    int counter = 0;
    for (final dto in dtoList) {
      isPaymentLoading.value = true;
      final result2 = await _repository.patchProduct(dto: dto);
      isPaymentLoading.value = false;
      result2.fold(
        (left) => Get.showSnackbar(
          GetSnackBar(
            message: '${LocaleKeys.error.tr} : $left',
            duration: const Duration(seconds: 2),
          ),
        ),
        (right) {
          counter++;
        },
      );
    }
    if (counter == selectedProducts.length) {
      counter = 0;
      await removeFromSelectedProducts(counter);
    } else {
      await patchToProductsAndRemoveFromSelectedProducts(dtoList);
    }
  }

  Future<void> removeFromSelectedProducts(int counter) async {
    for (final product in selectedProducts) {
      isPaymentLoading.value = true;
      final result3 = await _repository.deleteSelectedProduct(id: product.id);
      isPaymentLoading.value = false;
      result3.fold(
          (left) => Get.showSnackbar(
                GetSnackBar(
                  message: '${LocaleKeys.error.tr} : $left',
                  duration: const Duration(seconds: 2),
                ),
              ),
          (right) => counter++);
    }
    if (counter == selectedProducts.length) {
      selectedProducts.clear();
      Get.back();
    } else {
      await removeFromSelectedProducts(counter);
    }
  }
}
