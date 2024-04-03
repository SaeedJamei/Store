import 'package:get/get.dart';
import '../controllers/admin_add_product_controller.dart';

class AdminAddProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AdminAddProductController());
  }

}