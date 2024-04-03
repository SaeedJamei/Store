import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/locales.g.dart';
import '../controllers/admin_home_controller.dart';
import '../models/admin_home_view_model.dart';

class AdminHomeListItem extends GetView<AdminHomeController> {
  final AdminHomeViewModel product;
  final int index;

  const AdminHomeListItem(
      {required this.product, required this.index, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _productImage(),
                  _sizeBox(),
                  _tittleAndEditButton(),
                  _sizeBox(),
                  _description(),
                  _sizeBox(),
                  _priceAndCount(),
                  _sizeBox(),
                  _colorsList(),
                  _sizeBox(),
                  _activeButton(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sizeBox() => const SizedBox(
        height: 8,
      );

  Widget _activeButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            '${LocaleKeys.active.tr} :',
            overflow: TextOverflow.ellipsis,
          )),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: product.isActive,
              onChanged: (value) => controller.isActiveDisable.value
                  ? null
                  : controller.onActiveSwitchTap(value, product),
            ),
          )
        ],
      );

  Widget _tittleAndEditButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              product.tittle,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
          ),
          IconButton(
              onPressed: () => controller.onEditIconTap(product.id),
              icon: const Icon(Icons.edit))
        ],
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
        maxLines: 5,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ));

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
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: Text(
                '${product.price} \$',
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${LocaleKeys.count.tr} : ',
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  product.count.toString(),
                  textAlign: TextAlign.end,
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
