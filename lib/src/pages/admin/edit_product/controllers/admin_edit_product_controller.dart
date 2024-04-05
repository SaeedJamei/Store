import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/admin_edit_product_dto.dart';
import '../repositories/admin_edit_product_repository.dart';
import '../../../../../generated/locales.g.dart';

class AdminEditProductController extends GetxController {
  final int productId;

  AdminEditProductController(this.productId);

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }

  final AdminEditProductRepository _repository = AdminEditProductRepository();
  final TextEditingController tittleTextController = TextEditingController(),
      descriptionTextController = TextEditingController(),
      priceTextController = TextEditingController(),
      countTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  RxList<String> colors = RxList();
  RxString image = ''.obs;
  Rx<Color> pickedColor = const Color(0xff04927c).obs;
  RxBool isActive = true.obs;
  RxBool isGetProductLoading = false.obs;
  RxBool isGetProductRetry = false.obs;
  RxBool isEditLoading = false.obs;

  Future<void> getProduct() async {
    isGetProductRetry.value = false;
    isGetProductLoading.value = true;
    final result = await _repository.getProductById(id: productId);
    isGetProductLoading.value = false;
    result.fold((left) {
      isGetProductRetry.value = true;
      Get.showSnackbar(GetSnackBar(
        message: '${LocaleKeys.error.tr} : $left',
        duration: const Duration(seconds: 2),
      ));
    }, (right) {
      tittleTextController.text = right.tittle;
      descriptionTextController.text = right.description ?? '';
      priceTextController.text = right.price.toString();
      countTextController.text = right.count.toString();
      colors.addAll(right.colors);
      image.value = right.image ?? '';
      isActive.value = right.isActive;
    });
  }

  Future<void> onEditPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isEditLoading.value = true;
    final result = await _repository.patchProduct(
      dto: AdminEditProductDto(
        descriptionTextController.text,
        image.value,
        colors,
        id: productId,
        tittle: tittleTextController.text,
        count: int.parse(countTextController.text),
        price: int.parse(priceTextController.text),
        isActive: isActive.value,
      ),
    );
    isEditLoading.value = false;
    result.fold(
      (left) {
        Get.showSnackbar(GetSnackBar(
          message: '${LocaleKeys.error.tr} : $left',
          duration: const Duration(seconds: 2),
        ));
      },
      (right) => Get.back(result: right),
    );
  }

  Future<void> onAddImagePressed() async {
    final picker = ImagePicker();
    final imagePicked = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      List<int> imageBytes = await imagePicked.readAsBytes();
      image.value = base64Encode(imageBytes);
    } else {
      Get.showSnackbar(
        GetSnackBar(
          message: LocaleKeys.imageIsNotSelect.tr,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void onDeleteImagePressed() {
    image.value = '';
  }

  void onColorChange(Color color) {
    pickedColor.value = color;
  }

  void onColorRemoveTap(int index) {
    colors.removeAt(index);
  }

  void onColorPickersOkPressed() {
    colors.add(pickedColor.value.toString().split('(0x')[1].split(')')[0]);
  }
}
