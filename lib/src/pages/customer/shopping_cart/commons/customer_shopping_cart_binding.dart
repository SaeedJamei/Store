import 'package:get/get.dart';
import '../controllers/customer_shopping_cart_controller.dart';

class CustomerShoppingCartBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerShoppingCartController());
  }

}