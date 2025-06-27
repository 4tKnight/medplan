import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class HealthArticleService {
  final ApiClient _apiClient = ApiClient();


  Future<dynamic> viewHealthArticles() async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
    };

    my_log(healthArticleData);
    final response = await _apiClient.httpPost(
      Endpoints.viewHealthArticles,
      healthArticleData,
    );
    return response;
  }

  Future<dynamic> incHealthArticleShareCount({
    required String healthArticleId,
    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'health_article_id': healthArticleId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.incHealthArticleShareCount,
      healthArticleData,
    );
    return response;
  }
  Future<dynamic> commentHealthArticle({
       required String healthArticleId,
       required String comment,


    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'health_article_id': healthArticleId,
'comment':comment,
'owner_name':getX.read(v.GETX_USERNAME),
    };
    final response = await _apiClient.httpPost(
      
      Endpoints.commentHealthArticle,
      healthArticleData,
    );
    return response;
  }

 Future<dynamic> viewHealthArticleComments({
    required String healthArticleId,
    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'health_article_id': healthArticleId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewHealthArticleComments,
      healthArticleData,
    );
    return response;
  }



  Future<dynamic> likeHealthArticle({
    required String healthArticleId,
    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'health_article_id': healthArticleId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.likeHealthArticle,
      healthArticleData,
    );
    return response;
  }
  Future<dynamic> viewHealthArticleCommentReplies({
    required String commentId,
    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewHealthArticleCommentReplies,
      healthArticleData,
    );
    return response;
  }
  Future<dynamic> likeHealthArticleComment({
    required String commentId,
    }) async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.likeHealthArticleComment,
      healthArticleData,
    );
    return response;
  }

  Future<dynamic> searchHealthArticle() async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
    };
    final response = await _apiClient.httpPost(
      Endpoints.searchHealthArticle,
      healthArticleData,
    );
    return response;
  }

  Future<dynamic> viewTopArticles() async {
    Map<String, dynamic> healthArticleData = {
      'token': getX.read(v.TOKEN),
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewTopArticles,
      healthArticleData,
    );
    return response;
  }
}
