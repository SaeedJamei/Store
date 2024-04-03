import 'package:get/get.dart';
import '../controllers/admin_edit_product_controller.dart';

class AdminEditProductBinding extends Bindings{
  @override
  void dependencies() {
    final int productId = int.parse(Get.parameters['id']!);
    Get.lazyPut(() => AdminEditProductController(productId));
  }

}