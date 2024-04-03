import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:store/src/pages/customer/shopping_cart/models/customer_shopping_cart_selected_product_dto.dart';
import '../../../../infrastructure/commons/repository_urls.dart';
import '../models/customer_shopping_cart_product_dto.dart';
import '../models/customer_shopping_cart_selected_product_view_model.dart';
import '../models/customer_shopping_cart_product_view_model.dart';

class CustomerShoppingCartRepository {
  Future<Either<String, List<CustomerShoppingCartSelectedProductViewModel>>>
  getSelectedProductsByUserId({required int userId}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.getSelectedProducts,{'userId': userId.toString()});
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        List<dynamic> productsJson = jsonDecode(response.body);
        List<CustomerShoppingCartSelectedProductViewModel> products = [];
        for (final json in productsJson) {
          final product =
              CustomerShoppingCartSelectedProductViewModel.fromJson(json);
          products.add(product);
        }
        return Right(products);
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> patchProduct(
      {required CustomerShoppingCartProductDto dto}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.patchProduct(id: dto.id));
      final response = await http.patch(
        url,
        body: jsonEncode(
          dto.toJson(),
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 400) {
        return Right(
          jsonDecode(response.body),
        );
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> patchSelectedProduct(
      {required CustomerShoppingCartSelectedProductDto dto}) async {
    try {
      final url = Uri.http(RepositoryUrls.webBaseUrl,
          RepositoryUrls.patchSelectedProduct(id: dto.id));
      final response = await http.patch(
        url,
        body: jsonEncode(
          dto.toJson(),
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 400) {
        return Right(
          jsonDecode(response.body),
        );
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, String>> deleteSelectedProduct(
      {required int id}) async {
    try {
      final url = Uri.http(RepositoryUrls.webBaseUrl,
          RepositoryUrls.deleteSelectedProductById(id: id));
      final response = await http.delete(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        return Right(response.body);
      } else {
        return Left(response.body);
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, CustomerShoppingCartProductViewModel>> getProducts(
      {required int id}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.getProductById(id: id));
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        Map<String , dynamic> productJson = jsonDecode(response.body);
          final product = CustomerShoppingCartProductViewModel.fromJson(productJson);
        return Right(product);
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }
}
