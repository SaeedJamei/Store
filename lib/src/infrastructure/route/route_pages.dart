import 'package:get/get.dart';
import '../../pages/customer/shopping_cart/views/customer_shopping_cart_page.dart';
import '../../pages/splash/commons/splash_binding.dart';
import '../../pages/splash/views/splash_page.dart';
import 'route_names.dart';
import '../../pages/customer/home/commons/customer_home_binding.dart';
import '../../pages/customer/home/views/customer_home_page.dart';
import '../../pages/admin/add_product/commons/admin_add_product_binding.dart';
import '../../pages/admin/home/commons/admin_home_binding.dart';
import '../../pages/admin/home/views/admin_home_page.dart';
import '../../pages/login/commons/login_binding.dart';
import '../../pages/login/views/login_page.dart';
import '../../pages/admin/add_product/views/admin_add_product_page.dart';
import '../../pages/admin/edit_product/commons/admin_edit_product_binding.dart';
import '../../pages/admin/edit_product/views/admin_edit_product_page.dart';
import '../../pages/customer/detail_product/commons/customer_detail_product_binding.dart';
import '../../pages/customer/detail_product/views/customer_detail_product_page.dart';
import '../../pages/customer/shopping_cart/commons/customer_shopping_cart_binding.dart';
import '../../pages/signup/commons/signup_binding.dart';
import '../../pages/signup/views/signup_page.dart';


class RoutePages {
  static List<GetPage> pages = [
    GetPage(
      name: RouteNames.splashPage,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouteNames.loginPage,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      children: [
        GetPage(
          name: RouteNames.signupPage,
          page: () => const SignupPage(),
          binding: SignupBinding(),
        ),
      ],
    ),
    GetPage(
      name: RouteNames.adminHomePage,
      page: () => const AdminHomePage(),
      binding: AdminHomeBinding(),
      children: [
        GetPage(
          name: RouteNames.adminAddProductPage,
          page: () => const AdminAddProductPage(),
          binding: AdminAddProductBinding(),
        ),
        GetPage(
          name: RouteNames.adminEditProductPage,
          page: () => const AdminEditProductPage(),
          binding: AdminEditProductBinding(),
        ),
      ]
    ),
    GetPage(
      name: RouteNames.customerHomePage,
      page: () => const CustomerHomePage(),
      binding: CustomerHomeBinding(),
      children: [
        GetPage(
          name: RouteNames.customerDetailProductPage,
          page: () => const CustomerDetailProductPage(),
          binding: CustomerDetailProductBinding(),
        ),
        GetPage(
          name: RouteNames.customerShoppingCartPage,
          page: () => const CustomerShoppingCartPage(),
          binding: CustomerShoppingCartBinding(),
        ),
      ]
    ),
  ];
}
