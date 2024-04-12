import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../generated/locales.g.dart';
import '../models/admin_add_product_dto.dart';
import 'dart:convert';
import '../repositories/admin_add_product_repository.dart';
import 'package:store/src/infrastructure/commons/params.dart';

class AdminAddProductController extends GetxController {
  final AdminAddProductRepository _repository = AdminAddProductRepository();
  final TextEditingController tittleTextController = TextEditingController(),
      descriptionTextController = TextEditingController(),
      priceTextController = TextEditingController(),
      countTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  Rx<String> imageToString = "".obs;
  Rx<Color> pickedColor = const Color(0xff04927c).obs;
  RxList<String> colors = RxList();
  RxBool isLoading = false.obs;

  Future<void> onAddImagePressed() async {
    final picker = ImagePicker();
    final imagePicked = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      List<int> imageBytes = await imagePicked.readAsBytes();
      imageToString.value = base64Encode(imageBytes);
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
    imageToString.value = '';
  }

  void onColorChange(Color color) {
    pickedColor.value = color;
  }

  void onColorRemoveTap(int index) {
    colors.removeAt(index);
  }

  String? countFieldValidator(value) {
    return value == null || value.isEmpty ? LocaleKeys.thisIsRequired.tr : null;
  }

  String? priceFieldValidator(value) {
    return value == null || value.isEmpty ? LocaleKeys.thisIsRequired.tr : null;
  }

  String? titleFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  Future<void> onRegisterPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
    final result =
        await _repository.getProductByTittle(tittle: tittleTextController.text);
    isLoading.value = false;
    result.fold(
      (left) {
        Get.showSnackbar(
          GetSnackBar(
            message: '${LocaleKeys.error.tr} : $left',
            duration: const Duration(seconds: 2),
          ),
        );
      },
      (right) async {
        if (right.isEmpty) {
          isLoading.value = true;
          final result = await _repository.postProduct(
            dto: AdminAddProductDto(
              descriptionTextController.text,
              imageToString.value,
              colors,
              tittle: tittleTextController.text,
              count: int.parse(countTextController.text.trim()),
              price: int.parse(priceTextController.text.trim()),
              sellerId: Params.userId!,
            ),
          );
          isLoading.value = false;
          result.fold(
            (left) {
              Get.showSnackbar(GetSnackBar(
                message: '${LocaleKeys.error.tr} : $left',
                duration: const Duration(seconds: 2),
              ));
            },
            (right) => Get.back(result: right),
          );
        } else {
          Get.showSnackbar(
            GetSnackBar(
              message: LocaleKeys.thisProductIsExist.tr,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  void onColorPickersOkPressed() {
    colors.add(pickedColor.value.toString().split('(0x')[1].split(')')[0]);
  }
}
