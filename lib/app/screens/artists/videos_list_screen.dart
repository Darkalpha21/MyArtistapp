import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/video_link.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosListScreen extends StatefulWidget {

  final Artists? artists;

  const VideosListScreen({super.key,this.artists});

  @override
  State<StatefulWidget> createState() {
    return VideosListScreenState();
  }
}

class VideosListScreenState extends Base<VideosListScreen> {
  Artists? artists;

  @override
  void initState() {
    super.initState();
    artists = widget.artists;
    getOdooInstance().then((odoo) {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.artists!.name,
      ),
      body: Stack(children: [
          Container(
          color: Colors.white,
          padding: EdgeInsets.all(5.sp),
          child:
          ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: artists!.videoLinkData!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      VideoLink videoLink = artists!.videoLinkData![index];
                      return
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top:10.sp,bottom: 10.sp),
                      child:
                      Column(
                        children: [

                          Container(
                            padding: EdgeInsets.all(5.sp),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(3.sp),
                                child: Center(
                                  child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child:
                                      videoLink.videoLink!.contains('youtube') || videoLink.videoLink!.contains('youtu.be') ?
                                      YoutubePlayerBuilder(
                                        onExitFullScreen: () {
                                          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                                        },
                                        player: YoutubePlayer(
                                          controller: videoLink.youtubePlayerController!,
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor: Colors.blueAccent,
                                          topActions: <Widget>[
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                              child: Text(
                                                videoLink.youtubePlayerController!.metadata.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.settings,
                                                color: Colors.white,
                                                size: 25.0,
                                              ),
                                              onPressed: () {
                                                log('Settings Tapped!');
                                              },
                                            ),
                                          ],
                                          onEnded: (data) {
                                            videoLink.youtubePlayerController!.load(videoLink.videoId!);
                                          },
                                        ),
                                        builder: (context, player) => Scaffold(
                                          appBar: AppBar(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(left: 12.0),
                                              child: Image.asset(
                                                'assets/ypf.png',
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            title: const Text(
                                              'Youtube Player Flutter',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                          :
                                      VideoPlayer(videoLink.videoController!)
                                    // WebViewWidget(
                                    //   controller: _controller
                                    //     ..loadRequest(Uri.parse(artists!.videoLink!)),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        launchURL(videoLink.videoLink!);
                                      },
                                      child:
                                      Row(
                                        children: [
                                          Text(
                                            "Open Here",
                                            style: poppinsBold.copyWith(
                                                color: ThemeService().getDarkTheme()
                                                    ? Colors.white
                                                    : ColorConstants.android_red_dark),
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              )
                          ),
                        ],
                      ))
                     ;
                    },
                  ),
                ],
              )
            ],
          )


      ),
   ]) );
  }

}
