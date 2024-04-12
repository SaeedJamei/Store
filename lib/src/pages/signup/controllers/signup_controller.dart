import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../models/signup_dto.dart';
import '../repositories/signup_repository.dart';

class SignupController extends GetxController {
  final SignupRepository _repository = SignupRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController firstNameTextController = TextEditingController(),
      lastNameTextController = TextEditingController(),
      userNameTextController = TextEditingController(),
      passwordTextController = TextEditingController(),
      repeatPasswordTextController = TextEditingController();
  RxBool isAdmin = false.obs;
  RxBool isLoading = false.obs;

  void onRadioListTap(newValue) {
    isAdmin.value = newValue;
  }

  String? repeatPasswordFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : value != passwordTextController.text
            ? LocaleKeys.thisIsWrong.tr
            : null;
  }

  String? passwordFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : value.trim().length < 5
            ? LocaleKeys.errorPassword.tr
            : null;
  }

  String? usernameFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  String? lastnameFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  String? firstnameFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  Future<void> onSignupTap() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
    final result = await _repository.getUserByUserName(
        userName: userNameTextController.text.trim());
    isLoading.value = false;
    result.fold((left) {
      return Get.showSnackbar(
        GetSnackBar(
          message: '${LocaleKeys.error.tr} : $left',
          duration: const Duration(seconds: 2),
        ),
      );
    }, (right) async {
      if (right.isEmpty) {
        isLoading.value = true;
        final result = await _repository.postUser(
          dto: SignupDto(
            firstName: firstNameTextController.text.trim(),
            lastName: lastNameTextController.text.trim(),
            userName: userNameTextController.text.trim(),
            password: passwordTextController.text.trim(),
            isAdmin: isAdmin.value,
          ),
        );
        isLoading.value = false;
        result.fold(
            (left) => Get.showSnackbar(
                  GetSnackBar(
                    message: '${LocaleKeys.error.tr} : $left',
                    duration: const Duration(seconds: 2),
                  ),
                ), (right) {
          Get.back(result: {
            'userName': right['userName'],
            'password': right['password']
          });
        });
      } else {
        Get.showSnackbar(
          GetSnackBar(
            message: LocaleKeys.thisUsernameIsExist.tr,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}
