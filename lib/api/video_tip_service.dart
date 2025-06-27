
import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class VideoTipService {
  final ApiClient _apiClient = ApiClient();


  Future<dynamic> viewVideoTips() async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
    };

    final response = await _apiClient.httpPost(
      Endpoints.viewVideoTips,
      videoTipData,
    );
    return response;
  }

  Future<dynamic> incVideoTipshareCount({
    required String videoTipId,
    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'video_tip_id': videoTipId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.incVideoTipShareCount,
      videoTipData,
    );
    return response;
  }
  Future<dynamic> commentVideoTip({
       required String videoTipId,
       required String comment,


    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'video_tip_id': videoTipId,
'comment':comment,
'owner_name':getX.read(v.GETX_USERNAME),
    };
    final response = await _apiClient.httpPost(
      
      Endpoints.commentVideoTip,
      videoTipData,
    );
    return response;
  }

 Future<dynamic> viewVideoTipComments({
    required String videoTipId,
    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'video_tip_id': videoTipId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewVideoTipComments,
      videoTipData,
    );
    return response;
  }

  Future<dynamic> likeVideoTip({
    required String videoTipId,
    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'video_tip_id': videoTipId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.likeVideoTip,
      videoTipData,
    );
    return response;
  }


    Future<dynamic> viewVideoTipCommentReplies({
    required String commentId,
    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewVideoTipCommentReplies,
      videoTipData,
    );
    return response;
  }

  Future<dynamic> likeVideoTipComment({
    required String commentId,
    }) async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.likeVideoTipComment,
      videoTipData,
    );
    return response;
  }
  Future<dynamic> searchVideoTip() async {
    Map<String, dynamic> videoTipData = {
      'token': getX.read(v.TOKEN),
    };
    final response = await _apiClient.httpPost(
      Endpoints.searchVideoTip,
      videoTipData,
    );
    return response;
  }
}
