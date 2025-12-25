

import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLink {
  int? id;
  String? videoLink;
  VideoPlayerController? videoController;
  YoutubePlayerController? youtubePlayerController;
  String? videoId;
  // TextEditingController? idController;
  // TextEditingController? seekToController;
  // PlayerState? playerState;
  // YoutubeMetaData? videoMetaData;

  VideoLink();

  VideoLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoLink = json['video_link'] is! bool ? json["video_link"] : "";

      if (videoLink!.contains('youtube') || videoLink!.contains('youtu.be')) {
        videoId = YoutubePlayer.convertUrlToId(videoLink!);
        youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )
    // .
        // .addListener(listener)
    ;
        // idController = TextEditingController();
        // seekToController = TextEditingController();
        // videoMetaData = const YoutubeMetaData();
        // playerState = PlayerState.unknown;
      }
      else
      {
        videoController = VideoPlayerController.networkUrl(Uri.parse(videoLink!))
          ..initialize().then((_) {
            // videoController!.play();
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

          });
      }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video_link'] = videoLink;
    data['videoController'] = videoController;
    data['youtubePlayerController'] = youtubePlayerController;
    data['videoId'] = videoId;

    return data;
  }

}
