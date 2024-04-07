import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_number_picker/product_number_picker.dart';
import '../../../../../generated/locales.g.dart';
import '../controllers/customer_shopping_cart_controller.dart';
import '../models/customer_shopping_cart_selected_product_view_model.dart';

class CustomerShoppingCartListItem
    extends GetView<CustomerShoppingCartController> {
  final CustomerShoppingCartSelectedProductViewModel product;
  final int index;

  const CustomerShoppingCartListItem(
      {required this.product, required this.index, super.key});

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _tittleAndDeleteButton(),
                  _sizeBox(),
                  _priceAndNumberPicker(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sizeBox() =>
      const SizedBox(
        height: 8,
      );

  Widget _tittleAndDeleteButton() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                product.tittle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          IconButton(
            onPressed: () =>
            controller.isDisable.value
                ? null
                : controller.onDeleteTap(product: product, index: index),
            icon: const Icon(Icons.delete),
          ),
        ],
      );

  Widget _priceAndNumberPicker() {
    return Obx(
          () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
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
                      '${product.selectedCount * product.price} \$',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            _numberPicker(),
          ],
        );
      },
    );
  }

  Widget _numberPicker() =>
      ProductNumberPicker(
        isDisable: controller.isDisable.value,
        initialValue: product.selectedCount,
        onIncrease: (newValue) =>
            controller.onIncreaseTap(newValue, product, index),
        onDecrease: (newValue) =>
            controller.onDecreaseTap(newValue, product, index),
        minValue: 1,
        maxValue: product.count,
      );

}
