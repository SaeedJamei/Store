import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:store/src/pages/admin/edit_product/models/admin_edit_product_view_model.dart';
import '../models/admin_edit_product_dto.dart';
import '../../../../infrastructure/commons/repository_urls.dart';
import 'package:http/http.dart' as http;

class AdminEditProductRepository{

  Future<Either<String, AdminEditProductViewModel>> getProductById({required int id}) async {
    try {
      final url =
      Uri.http(
          RepositoryUrls.webBaseUrl, RepositoryUrls.getProductById(id: id));
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        Map<String, dynamic> productJson = jsonDecode(response.body);
        AdminEditProductViewModel product = AdminEditProductViewModel.fromJson(
            productJson);
        return Right(product);
      } else {
        return Left(response.statusCode.toString());
      }
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String ,dynamic>>> patchProduct(
      {required AdminEditProductDto dto}) async {
    try{
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
      }else{
        return Left(response.statusCode.toString());
      }
    }catch(error){
      return Left(error.toString());
    }
  }

}