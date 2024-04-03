import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/repository_urls.dart';
import '../models/signup_dto.dart';

class SignupRepository {
  Future<Either<String, Map<String, dynamic>>> postUser(
      {required SignupDto dto}) async {
    try {
      final url = Uri.http(RepositoryUrls.webBaseUrl, RepositoryUrls.postUser);
      final response = await http.post(url, body: jsonEncode(dto.toJson(),),
        headers: {'Content-Type': 'application/json'},);
      if(response.statusCode >= 200 && response.statusCode < 400){
        return Right(jsonDecode(response.body));
      }else{
        return Left(response.statusCode.toString());
      }
    }catch(error){
      return Left(error.toString());
    }
  }

  Future<Either<String , List<dynamic>>> getUserByUserName({required String userName}) async{
    try{
      final url = Uri.http(RepositoryUrls.webBaseUrl , RepositoryUrls.getUser , {'userName':userName});
      final response = await http.get(url);
      if(response.statusCode >= 200 && response.statusCode < 400){
        return Right(jsonDecode(response.body));
      }else{
        return Left(response.statusCode.toString());
      }
    }catch(error){
      return Left(error.toString());
    }
  }
}