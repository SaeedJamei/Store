import 'package:get/get.dart';
import '../controllers/customer_detail_product_controller.dart';

class CustomerDetailProductBinding extends Bindings{
  @override
  void dependencies() {
    final int productId = int.parse(Get.parameters['productId']!);
    Get.lazyPut(() => CustomerDetailProductController(productId: productId ));
  }

}