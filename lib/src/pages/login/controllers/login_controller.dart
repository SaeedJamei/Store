import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/src/infrastructure/commons/params.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/route/route_names.dart';
import '../models/login_view_model.dart';
import '../repositories/login_repository.dart';

class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController userNameTextController = TextEditingController(),
      passwordTextController = TextEditingController();
  final SharedPreferences _preferences = Get.find<SharedPreferences>();
  RxBool isPasswordInvisible = true.obs;
  RxBool isLoading = false.obs;
  RxBool isRemember = false.obs;

  void onEyeTap() {
    isPasswordInvisible.value = !isPasswordInvisible.value;
  }

  void onRememberCheckChange(newValue) {
    isRemember.value = newValue;
  }

  Future<void> onSignupTap() async {
    userNameTextController.clear();
    passwordTextController.clear();
    final result =
        await Get.toNamed(RouteNames.loginPage + RouteNames.signupPage);
    if (result != null) {
      userNameTextController.text = result['userName'];
      passwordTextController.text = result['password'];
    }
  }

  void updateAppLanguage({required Locale locale}) => Get.updateLocale(locale);

  String? usernameFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  String? passwordFieldValidator(value) {
    return value == null || value.trim().isEmpty
        ? LocaleKeys.thisIsRequired.tr
        : null;
  }

  Future<void> onLoginTap() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
    final result = await _repository.getUserByUserName(
        userName: userNameTextController.text.trim());
    isLoading.value = false;
    result.fold(
      (left) {
        return Get.showSnackbar(
          GetSnackBar(
            message: '${LocaleKeys.error.tr} : $left',
            duration: const Duration(seconds: 2),
          ),
        );
      },
      (right) async {
        if (right.isEmpty) {
          Get.showSnackbar(
            GetSnackBar(
              message: LocaleKeys.usernameOrPasswordIncorrect.tr,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          LoginViewModel user = LoginViewModel.fromJson(right[0]);
          if (user.password == passwordTextController.text.trim()) {
            Params.isAdmin = user.isAdmin;
            Params.userId = user.id;
            if (isRemember.value) {
              await _preferences.setInt('id', user.id);
              await _preferences.setBool('isAdmin', user.isAdmin);
            }
            if (user.isAdmin) {
              Get.offNamed(
                RouteNames.adminHomePage,
              );
            } else {
              Get.offNamed(RouteNames.customerHomePage);
            }
          } else {
            Get.showSnackbar(
              GetSnackBar(
                message: LocaleKeys.usernameOrPasswordIncorrect.tr,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
    );
  }
}
