import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_add_product_controller.dart';
import '../../../../../generated/locales.g.dart';

class AdminAddProductPage extends GetView<AdminAddProductController> {
  const AdminAddProductPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.addProduct.tr),
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _image(),
                _forms(),
                _addColors(context),
                _registerButton()
              ],
            ),
          ),
        ),
      );

  Widget _registerButton() => Obx(() => ElevatedButton(
      onPressed:
          controller.isLoading.value ? null : controller.onRegisterPressed,
      child: controller.isLoading.value
          ? Transform.scale(scale: 0.75 ,child: const CircularProgressIndicator())
          : Text(LocaleKeys.register.tr)));

  Widget _addColors(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  LocaleKeys.color.tr,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                )),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _openColorPicker(context));
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            _colorsList(),
          ],
        ),
      );

  Widget _colorsList() => Obx(
        () => SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.colors.length,
            itemBuilder: (context, index) => _listItem(index),
          ),
        ),
      );

  Widget _listItem(int index) => Stack(children: [
        Icon(Icons.circle,
            color: Color(
              int.parse(controller.colors[index], radix: 16),
            )),
        Positioned(
          bottom: 25,
          left: 10,
          child: InkWell(
            onTap: () => controller.onColorRemoveTap(index),
            child: const Icon(
              Icons.remove,
              color: Colors.red,
            ),
          ),
        ),
      ]);

  Widget _forms() => Form(
        key: controller.formKey,
        child: Column(
          children: [
            _titleField(),
            _descriptionField(),
            _priceField(),
            _countField(),
          ],
        ),
      );

  Widget _countField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 10,
        controller: controller.countTextController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => value == null || value.isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.count.tr,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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

  Padding _priceField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 10,
        controller: controller.priceTextController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => value == null || value.isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.price.tr,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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

  Padding _descriptionField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 1000,
        controller: controller.descriptionTextController,
        maxLines: 5,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.description.tr,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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

  Padding _titleField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 100,
        controller: controller.tittleTextController,
        validator: (value) => value == null || value.trim().isEmpty
            ? LocaleKeys.thisIsRequired.tr
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            LocaleKeys.tittle.tr,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Obx(
          () => Stack(
            children: [
              _showImage(),
              _addImageButton(),
              if (controller.imageToString.value != '') _deleteImageButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addImageButton() => Positioned(
        bottom: 1,
        right: 1,
        child: IconButton(
          onPressed: controller.onAddImagePressed,
          icon: const Icon(Icons.photo_library),
          color: Colors.orange,
        ),
      );

  Widget _deleteImageButton() => Positioned(
        bottom: 1,
        left: 1,
        child: IconButton(
          onPressed: controller.onDeleteImagePressed,
          icon: const Icon(Icons.delete_forever_outlined),
          color: Colors.orange,
        ),
      );

  Widget _showImage() => DecoratedBox(
        decoration: controller.imageToString.value == ''
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                  )
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image:
                      MemoryImage(base64Decode(controller.imageToString.value)),
                ),
              ),
        child: const SizedBox(
          height: 250,
          width: 400,
        ),
      );

  Widget _openColorPicker(BuildContext context) => AlertDialog(
        title: Text(
          LocaleKeys.selectAColor.tr,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: controller.pickedColor.value,
            onColorChanged: (color) => controller.onColorChange(color),
          ),
        ),
        actions: [
          TextButton(
            child: Text(LocaleKeys.ok.tr),
            onPressed: () {
              controller.onColorPickersOkPressed();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}
