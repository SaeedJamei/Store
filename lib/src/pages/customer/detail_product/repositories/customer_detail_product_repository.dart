import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/commons/repository_urls.dart';
import '../models/customer_detail_product_view_model.dart';
import '../models/customer_detail_selected_product_patch_dto.dart';
import '../models/customer_detail_selected_product_post_dto.dart';

class CustomerDetailProductRepository {
  Future<Either<String, CustomerDetailProductViewModel>> getProductById(
      {required int id}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.getProductById(id: id));
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        Map<String, dynamic> productJson = jsonDecode(response.body);
        CustomerDetailProductViewModel product =
            CustomerDetailProductViewModel.fromJson(productJson);
        return Right(product);
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<dynamic>>>
      getSelectedProductByProductIdAndUserId(
          {required int userId, required int productId}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl,
          RepositoryUrls.getSelectedProducts,
          {'productId': productId.toString(), 'userId': userId.toString()});
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
         return Right(jsonDecode(response.body));
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> postSelectedProduct(
      {required CustomerDetailSelectedProductPostDto dto}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.postSelectedProduct);
      final response = await http.post(
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
      {required CustomerDetailSelectedProductPatchDto dto}) async {
    try {
      final url = Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.patchSelectedProduct(id: dto.id));
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
}
