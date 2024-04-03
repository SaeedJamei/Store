import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../models/admin_home_dto.dart';
import '../../../../infrastructure/commons/repository_urls.dart';
import '../models/admin_home_view_model.dart';

class AdminHomeRepository {
  Future<Either<String, List<AdminHomeViewModel>>> getProducts({
    required int minPrice,
    required int maxPrice,
    required String? search,
  }) async {
    final String searchText = search ?? '';
    try {
      if(minPrice == 0 || maxPrice == 0){
        final url =
        Uri.http(RepositoryUrls.webBaseUrl, RepositoryUrls.getProduct, {
          'q': searchText,
        });
        final response = await http.get(url);
        if (response.statusCode >= 200 && response.statusCode < 400) {
          List<dynamic> productsJson = jsonDecode(response.body);
          List<AdminHomeViewModel> products = [];
          for (final json in productsJson) {
            final product = AdminHomeViewModel.fromJson(json);
            products.add(product);
          }
          return Right(products);
        } else {
          return Left(response.statusCode.toString());
        }
      }else {
        final url =
        Uri.http(RepositoryUrls.webBaseUrl, RepositoryUrls.getProduct, {
          'price_lte': maxPrice.toString(),
          'price_gte': minPrice.toString(),
          'q': searchText,
        });
        final response = await http.get(url);
        if (response.statusCode >= 200 && response.statusCode < 400) {
          List<dynamic> productsJson = jsonDecode(response.body);
          List<AdminHomeViewModel> products = [];
          for (final json in productsJson) {
            final product = AdminHomeViewModel.fromJson(json);
            products.add(product);
          }
          return Right(products);
        } else {
          return Left(response.statusCode.toString());
        }
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<AdminHomeViewModel>>>
  getProductsBySortPrice() async {
    try {
      final url = Uri.http(RepositoryUrls.webBaseUrl, RepositoryUrls.getProduct,
          {'_sort': 'price'});
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        List<dynamic> productsJson = jsonDecode(response.body);
        List<AdminHomeViewModel> products = [];
        for (final json in productsJson) {
          final product = AdminHomeViewModel.fromJson(json);
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

  Future<Either<String, AdminHomeViewModel>> patchProduct(
      {required AdminHomeDto dto}) async {
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
          AdminHomeViewModel.fromJson(
            jsonDecode(response.body),
          ),
        );
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }
}
