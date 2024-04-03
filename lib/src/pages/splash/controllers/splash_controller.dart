import 'package:get/get.dart';
import 'package:store/src/infrastructure/route/route_names.dart';
import '../../../infrastructure/commons/params.dart';

class SplashController extends GetxController{

  final String path = 'lib/assets/pics/apple.png';

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3)).then((value) => preferencesGet());
  }


  void preferencesGet(){
    if(Params.userId == null){
      Get.offNamed(RouteNames.loginPage);
    }else if(Params.isAdmin!){
      Get.offNamed(RouteNames.adminHomePage,);
    }else{
      Get.offNamed(RouteNames.customerHomePage,);
    }
  }
}