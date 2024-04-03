import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controllers/signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.signup.tr),
        ),
        body: _body(),
      );

  Widget _body() => SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _forms(),
                Obx(() => _radioList()),
                _signupButton(),
              ],
            ),
          ),
        ),
      );

  Widget _signupButton() => Obx(() {
        return ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.onSignupTap,
          child: controller.isLoading.value
              ? const CircularProgressIndicator()
              : Text(LocaleKeys.signup.tr),
        );
      });

  Widget _forms() => Form(
        key: controller.formKey,
        child: Column(
          children: [
            _firstnameField(),
            _lastnameField(),
            _usernameField(),
            _passwordField(),
            _repeatPasswordField(),
          ],
        ),
      );

  Padding _repeatPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller.repeatPasswordTextController,
        validator: (value) {
          return value == null || value.trim().isEmpty
              ? LocaleKeys.thisIsRequired.tr
              : value != controller.passwordTextController.text
                  ? LocaleKeys.thisIsWrong.tr
                  : null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.repeatPassword.tr,
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

  Padding _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 50,
        controller: controller.passwordTextController,
        validator: (value) => value == null || value.trim().isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : value.trim().length < 5
                ? LocaleKeys.errorPassword.tr
                : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
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
      ),
    );
  }

  Padding _usernameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 50,
        controller: controller.userNameTextController,
        validator: (value) => value == null || value.trim().isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
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

  Padding _lastnameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 50,
        controller: controller.lastNameTextController,
        validator: (value) => value == null || value.trim().isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.lastName.tr,
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

  Padding _firstnameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 50,
        controller: controller.firstNameTextController,
        validator: (value) => value == null || value.trim().isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.firstName.tr,
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

  Widget _radioList() => Column(
        children: [
          RadioListTile(
            title: Text(
              LocaleKeys.seller.tr,
              overflow: TextOverflow.ellipsis,
            ),
            value: true,
            groupValue: controller.isAdmin.value,
            onChanged: (value) => controller.onRadioListTap(value),
          ),
          RadioListTile(
            title: Text(
              LocaleKeys.customer.tr,
              overflow: TextOverflow.ellipsis,
            ),
            value: false,
            groupValue: controller.isAdmin.value,
            onChanged: (value) => controller.onRadioListTap(value),
          ),
        ],
      );
}
