import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_home_list_item.dart';
import '../../../../../generated/locales.g.dart';
import '../../../shared/widgets/price_range_slider.dart';
import '../controllers/admin_home_controller.dart';

class AdminHomePage extends GetView<AdminHomeController> {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.onAddPressed,
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _searchAndFilter(context),
                const SizedBox(
                  height: 10,
                ),
                _productsList(),
              ],
            ),
          ),
        ),
      );

  AppBar _appBar(BuildContext context) =>
      AppBar(title: Text(LocaleKeys.admin.tr), actions: [
        _menuButton(context),
      ]);

  Widget _menuButton(BuildContext context) => IconButton(
        onPressed: () => Get.dialog(
          AlertDialog(
            alignment: AlignmentDirectional.topEnd,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    _englishLanguageButton(context),
                    const SizedBox(
                      height: 10,
                    ),
                    _persianLanguageButton(context),
                  ],
                ),
                _logoutButton(),
              ],
            ),
          ),
        ),
        icon: const Icon(Icons.menu),
      );

  Widget _logoutButton() => IconButton(
        onPressed: controller.onLogoutPressed,
        icon: const Icon(Icons.logout),
      );

  Widget _persianLanguageButton(BuildContext context) => ElevatedButton(
        onPressed: () {
          controller.updateAppLanguage(locale: const Locale('fa', 'IR'));
          Navigator.of(context).pop();
        },
        child: const Row(
          children: [
            Icon(Icons.language),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                'فارسی',
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      );

  Widget _englishLanguageButton(BuildContext context) => ElevatedButton(
        onPressed: () {
          controller.updateAppLanguage(locale: const Locale('en', 'US'));
          Navigator.of(context).pop();
        },
        child: const Row(
          children: [
            Expanded(
              child: Text(
                'English',
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
            Icon(Icons.language),
          ],
        ),
      );

  Widget _productsList() => Obx(
        () {
          if (controller.isGetProductsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.isGetProductsRetry.value) {
            return Center(
              child: _retryButton(),
            );
          } else {
            return controller.products.isEmpty
                ? Text(
                    LocaleKeys.emptyList.tr,
                    overflow: TextOverflow.ellipsis,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) => AdminHomeListItem(
                          product: controller.products[index], index: index),
                    ),
                  );
          }
        },
      );

  Widget _retryButton() {
    return ElevatedButton(
      onPressed: () => controller.getProducts(
        searchText: controller.searchTextController.text,
      ),
      child: Text(LocaleKeys.retry.tr),
    );
  }

  Widget _searchAndFilter(BuildContext context) => Row(
        children: [
          _filterButton(context),
          _searchField(),
        ],
      );

  Widget _searchField() => Expanded(
        child: TextField(
          maxLength: 200,
          controller: controller.searchTextController,
          onChanged: (value) => controller.onSearchTextChange(value),
          decoration: const InputDecoration(
            counterText: '',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              )),
        ),
      );

  Widget _filterButton(BuildContext context) => IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Obx(
              () {
                return AlertDialog(
                  alignment: AlignmentDirectional.centerStart,
                  title: Text(
                    LocaleKeys.price.tr,
                    overflow: TextOverflow.ellipsis,
                  ),
                  content: PriceRangeSlider(
                    onRemoveFilterTap: controller.onRemoveFilterPressed,
                    onFilterTap: controller.onFilterPressed,
                    max: controller.maxPrice.value.toDouble(),
                    min: controller.minPrice.value.toDouble(),
                    onChange: controller.rangePriceOnChange,
                    values: controller.rangeSliderValues.value,
                  ),
                );
              },
            ),
          );
        },
        icon: const Icon(Icons.filter_list),
      );
}
