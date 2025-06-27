import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class ReplyCommentService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> commentReply({
    required String commentId,
    required String eventId,
    required String comment,
  }) async {
    Map<String, dynamic> replyCommentData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
      'event_id': eventId,
      'comment': comment,
      'owner_name': getX.read(v.GETX_USERNAME),
      'owner_img_url':
          getX.read(v.GETX_USER_IMAGE) == ''
              ? 'a'
              : getX.read(v.GETX_USER_IMAGE),
      'owner_img_id': getX.read(v.GETX_USER_IMAGE_ID) ?? 'a',
    };
    final response = await _apiClient.httpPost(
      Endpoints.commentReply,
      replyCommentData,
    );
    return response;
  }

  Future<dynamic> getRepliesPostComments({required String commentId}) async {
    my_log(commentId);
    Map<String, dynamic> replyCommentData = {
      'token': getX.read(v.TOKEN),
      'comment_id': commentId,
    };

    final response = await _apiClient.httpPost(
      Endpoints.getRepliesPostComments,
      replyCommentData,
    );
    return response;
  }

  Future<dynamic> togglelikeCommentReply({
    required String commentReplyId,
  }) async {
    Map<String, dynamic> replyCommentData = {
      'token': getX.read(v.TOKEN),
      'comment_reply_id': commentReplyId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.togglelikeCommentReply,
      replyCommentData,
    );
    return response;
  }

  //  Future<dynamic> unlikeCommentReply({
  //   required String commentId,
  // }) async {
  //   // token, owner_img_url, owner_name, comment_reply_id
  //   Map<String, dynamic> replyCommentData = {
  //     'token': getX.read(v.TOKEN),
  //     'comment_id': commentId,
  //   };
  //   final response = await _apiClient.httpPost(
  //     Endpoints.unlikeCommentReply,
  //     replyCommentData,
  //   );
  //   return response;
  // }
}
