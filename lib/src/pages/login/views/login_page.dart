import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.login.tr),
        ),
        body: _body(),
      );

  Widget _body() => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _formsAndRememberCheck(),
              _signupAndLoginButtons(),
              _language(),
            ],
          ),
        ),
      );

  Widget _signupAndLoginButtons() => Column(
        children: [
          _loginButton(),
          _signupButton(),
        ],
      );

  Widget _signupButton() => Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: controller.onSignupTap,
          child: Text(
            LocaleKeys.signup.tr,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );

  Padding _loginButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Obx(() {
        return ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.onLoginTap,
          child: controller.isLoading.value
              ? Transform.scale(scale: 0.75 ,child: const CircularProgressIndicator())
              : Text(LocaleKeys.login.tr),
        );
      }),
    );
  }

  Widget _language() => Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.updateAppLanguage(
                  locale: const Locale('en', 'US')),
              child: const Text(
                'English',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => controller.updateAppLanguage(
                  locale: const Locale('fa', 'IR')),
              child: const Text(
                'فارسی',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );

  Widget _formsAndRememberCheck() => Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userNameField(),
            _passwordField(),
            Obx(() {
              return Row(
                children: [
                  Checkbox(
                      value: controller.isRemember.value,
                      onChanged: (value) =>
                          controller.onRememberCheckChange(value)),
                  Expanded(
                    child: Text(
                      LocaleKeys.rememberMe.tr,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      );

  Padding _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return TextFormField(
          maxLength: 50,
          controller: controller.passwordTextController,
          validator: (value) => controller.passwordFieldValidator(value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: controller.isPasswordInvisible.value,
          decoration: InputDecoration(
            counterText: '',
            suffixIcon: InkWell(
                onTap: controller.onEyeTap,
                child: const Icon(Icons.remove_red_eye_outlined)),
            label: Text(
              LocaleKeys.password.tr,
              overflow: TextOverflow.ellipsis,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
        );
      }),
    );
  }

  Padding _userNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 50,
        controller: controller.userNameTextController,
        validator: (value) => controller.usernameFieldValidator(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          counterText: '',
          label: Text(
            LocaleKeys.userName.tr,
            overflow: TextOverflow.ellipsis,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
