// youtube_player_flutter: ^8.0.0
import 'package:flutter/services.dart';
import 'package:medplan/utils/global.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:medplan/main.dart';

class VideoPlayer extends StatefulWidget {
  String title;
  String link;
  String video_id;
  VideoPlayer(this.title, this.link, this.video_id, {Key? key})
    : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video_id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
    super.initState();
  }

  // Note that this method assumes that the URL is a valid YouTube video URL and
  //contains a v= parameter. It may not work for other types of URLs
  //or if the URL format changes in the future.
  String extractVideoIdFromYoutubeApp(String url) {
    print('----------VIDEO_ID ------->  $url');
    RegExp regExp = new RegExp(r'(?<=v=)[a-zA-Z0-9_-]+(?=&|\?)');
    String? match = regExp.stringMatch(url);
    return match ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();

    // Change the screen orientation back to portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: helperWidget.myAppBar(
        context,
        "Video Player",
        // bgColor: Colors.black87,
        isBack: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10.0, 5),
            child: Material(
              // shadowColor: Colors.red,
              shadowColor: Theme.of(context).shadowColor,
              elevation: 0.5,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Theme.of(context).shadowColor,
                dense: true,
                title: Text(widget.title.toUpperCase()),
                // trailing: Image.asset(
                //   "./assets/video.png",
                //   height: 25,
                //   width: 25,
                //   color: Colors.black,
                //   // color: darkNotifier.value ? Colors.white : Colors.black,
                // ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              //remove the bottomActions if you want the icon to control the speed to show
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                FullScreenButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  flick_video_player: ^0.4.0
// import 'package:video_player/video_player.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:medplan/main.dart';

// class VideoPlayer extends StatefulWidget {
//   String title;
//   String link;
//   VideoPlayer(this.title, this.link, {Key? key}) : super(key: key);

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   late FlickManager flickManager;
//   @override
//   void initState() {
//     super.initState();
//     // print('>>>>>>>>>>>>>>>>>>>>>>> ${widget.link} ');
//     flickManager = FlickManager(
//         // videoPlayerController: VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
//         // videoPlayerController: VideoPlayerController.network("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")
//         videoPlayerController: VideoPlayerController.network(widget.link));
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myWidgets.appBar(ctx: context, title: "Video Player"),
//       body: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(10, 5, 10.0, 5),
//             child: Material(
//               // shadowColor: Colors.red,
//               shadowColor: Theme.of(context).shadowColor,
//               elevation: 0.5,
//               borderRadius: BorderRadius.circular(8),
//               child: ListTile(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 tileColor: Theme.of(context).shadowColor,
//                 dense: true,
//                 title: Text(widget.title),
//                 trailing: Image.asset("./assets/video.png", height: 25, width: 25),
//               ),
//             ),
//           ),
//           SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: FlickVideoPlayer(flickManager: flickManager),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// chewie: ^1.3.3
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:medplan/main.dart';
// import 'package:chewie/chewie.dart';

// class VideoPlayer extends StatefulWidget {
//   String title;
//   String link;
//   VideoPlayer(this.title, this.link, {Key? key}) : super(key: key);

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();

//     _chewieController = ChewieController(
//       videoPlayerController: VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
//       // videoPlayerController: VideoPlayerController.network(widget.link),
//       aspectRatio: 16 / 9,
//       autoInitialize: true,
//       autoPlay: true,
//       // looping: true,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               errorMessage,
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // _chewieController!.videoPlayerController.dispose();
//     // _chewieController!.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myWidgets.appBar(ctx: context, title: "Video Player"),
//       body: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(10, 5, 10.0, 5),
//             child: Material(
//               shadowColor: Colors.grey[100],
//               elevation: 3.0,
//               borderRadius: BorderRadius.circular(8),
//               child: ListTile(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 tileColor: Colors.white,
//                 dense: true,
//                 title: Text(widget.title),
//                 trailing: Image.asset("./assets/video.png", height: 25, width: 25),
//               ),
//             ),
//           ),
//           SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Chewie(
//                 controller: _chewieController!,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
