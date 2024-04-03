import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../generated/locales.g.dart';
import '../controllers/customer_home_controller.dart';
import '../models/customer_home_product_view_model.dart';

class CustomerHomeListItem extends GetView<CustomerHomeController> {
  final CustomerHomeProductViewModel product;
  final int index;

  const CustomerHomeListItem(
      {required this.product, required this.index, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          onTap: () => controller.onProductTap(product.id),
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
                    _priceAndCount(),
                    _sizeBox(),
                    _colorsList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _sizeBox() => const SizedBox(
        height: 8,
      );

  Widget _tittle() => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          product.tittle,
          style: const TextStyle(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
        ),
      );

  Widget _productImage() {
    return DecoratedBox(
      decoration: product.image == ''
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
                image: MemoryImage(base64Decode(product.image!)),
              ),
            ),
      child: const SizedBox(
        height: 250,
        width: 400,
      ),
    );
  }

  Widget _description() => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          product.description ?? '',
          maxLines: 4,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      );

  Widget _priceAndCount() {
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
                  '${product.price} \$',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.end,
                  '${LocaleKeys.count.tr} : ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.end,
                  product.count.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _colorsList() => SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: product.colors.length,
          itemBuilder: (context, index) => _colorsListItem(index)));

  _colorsListItem(int index) => Icon(
        Icons.circle,
        color: Color(
          int.parse(product.colors[index], radix: 16),
        ),
      );
}
