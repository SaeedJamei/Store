import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customer/shopping_cart/controllers/customer_shopping_cart_controller.dart';
import '../../../customer/shopping_cart/views/customer_shopping_cart_list_item.dart';
import '../../../../../generated/locales.g.dart';

class CustomerShoppingCartPage extends GetView<CustomerShoppingCartController> {
  const CustomerShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.shoppingCart.tr),
        ),
        body: _body(),
      );

  Obx _body() {
    return Obx(
      () {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _productsList(),
                _totalPrice(),
                _paymentButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productsList() {
    return controller.isGetProductsLoading.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : controller.isGetProductsRetry.value
            ? Center(
                child: ElevatedButton(
                  onPressed: controller.getSelectedProductsByUserId,
                  child: Text(LocaleKeys.retry.tr),
                ),
              )
            : controller.products.isEmpty
                ? Text(
                    LocaleKeys.emptyList.tr,
                    overflow: TextOverflow.ellipsis,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) =>
                          CustomerShoppingCartListItem(
                        product: controller.products[index],
                        index: index,
                      ),
                    ),
                  );
  }

  Widget _totalPrice() => Row(
        children: [
          Expanded(
            child: Text(
              '${LocaleKeys.totalPrice.tr} :  ',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              '${controller.allTotalPrice.value} \$',
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  Widget _paymentButton() => ElevatedButton(
      onPressed:
          controller.products.isEmpty || controller.isPaymentLoading.value
              ? null
              : controller.onPaymentPressed,
      child: controller.isPaymentLoading.value
          ? Transform.scale(scale: 0.75 ,child: const CircularProgressIndicator())
          : Text(LocaleKeys.payment.tr));
}
