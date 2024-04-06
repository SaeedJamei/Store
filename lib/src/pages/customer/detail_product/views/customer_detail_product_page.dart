import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_number_picker/product_number_picker.dart';
import '../controllers/customer_detail_product_controller.dart';
import '../../../../../generated/locales.g.dart';

class CustomerDetailProductPage
    extends GetView<CustomerDetailProductController> {
  const CustomerDetailProductPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.selectProduct.tr),
        ),
        body: Obx(() {
          return _body();
        }),
      );

  Widget _body() {
    if (controller.isGetProductLoad.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (controller.isGetProductRetry.value) {
      return Center(
        child: ElevatedButton(
          onPressed: controller.getProduct,
          child: Text(LocaleKeys.retry.tr),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _productImage(),
                  _sizeBox(),
                  _tittle(),
                  _sizeBox(),
                  _description(),
                  _sizeBox(),
                  _price(),
                  _sizeBox(),
                  _colorsList(),
                  _numberPicker(),
                  _addToCartButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _sizeBox() => const SizedBox(
        height: 8,
      );

  Widget _addToCartButton() => Obx(() {
        return ElevatedButton(
          onPressed: controller.isAddToShoppingCartLoad.value
              ? null
              : controller.onAddToCartTap,
          child: controller.isAddToShoppingCartLoad.value
              ? Transform.scale(scale: 0.75 ,child: const CircularProgressIndicator())
              : Text(LocaleKeys.addToCart.tr),
        );
      });

  Widget _numberPicker() => Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ProductNumberPicker(
              initialValue: controller.selectedCount.value,
              onIncrease: (newValue) => controller.onIncreaseTap(newValue),
              onDecrease: (newValue) => controller.onDecreaseTap(newValue),
              minValue: 1,
              maxValue: controller.count.value,
            ),
          ],
        );
      });

  Widget _tittle() => Obx(() {
        return Align(alignment: AlignmentDirectional.centerStart,
          child: Text(
            controller.tittle.value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      });

  Widget _productImage() => Obx(() {
        return DecoratedBox(
          decoration: controller.image.value == ''
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
                    image: MemoryImage(base64Decode(controller.image.value)),
                  ),
                ),
          child: const SizedBox(
            height: 250,
            width: 400,
          ),
        );
      });

  Widget _description() => Obx(() {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            controller.description.value,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        );
      });

  Widget _price() => Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${LocaleKeys.price.tr} : ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${controller.price.value} \$",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      });

  _colorsList() => SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.colors.length,
          itemBuilder: (context, index) => _colorsListItem(index)));

  _colorsListItem(int index) => Icon(
        Icons.circle,
        color: Color(
          int.parse(controller.colors[index], radix: 16),
        ),
      );
}
