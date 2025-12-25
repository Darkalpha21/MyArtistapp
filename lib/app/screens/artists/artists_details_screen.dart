import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/attachments.dart';
import 'package:my_artist_demo/app/models/filter_artists.dart';
import 'package:my_artist_demo/app/screens/artists/images_list_screen.dart';
import 'package:my_artist_demo/app/screens/viewimage/view_image_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_snackbar.dart';
import 'package:my_artist_demo/app/widgets/sliverbar_with_card.dart';
import 'package:my_artist_demo/base.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'videos_list_screen.dart';


class ArtistsDetailsScreen extends StatefulWidget {
  final Artists? artists;

  const ArtistsDetailsScreen({super.key,  required this.artists});

  @override
  State<StatefulWidget> createState() {
    return ArtistsDetailsScreenState();
  }
}

class ArtistsDetailsScreenState extends Base<ArtistsDetailsScreen> {
  Artists? artists;
  Widget appBarTitle = Text("Artists", style: poppinsBold);
  FilterArtists? filterArtists;
  bool isFilter = false;
  String categoryDisplay = "";
  String tagDisplay = "";
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String? videoId;
  late final List<Attachments> _attachmentsList = [];

  @override
  void initState() {
    super.initState();
    artists = widget.artists;
    if(artists!.videoLinkData!.isNotEmpty && artists!.videoLinkData![0].videoLink! != "")
      {
        if (artists!.videoLinkData![0].videoLink!.contains('youtube') || artists!.videoLinkData![0].videoLink!.contains('youtu.be')) {
          videoId = YoutubePlayer.convertUrlToId(artists!.videoLinkData![0].videoLink!);
          _youtubePlayerController = YoutubePlayerController(
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
          )..addListener(listener);
          _idController = TextEditingController();
          _seekToController = TextEditingController();
          _videoMetaData = const YoutubeMetaData();
          _playerState = PlayerState.unknown;
          // _youtubePlayerController!.play();
          setState(() {

          });
        }
        else
        {
          _videoController = VideoPlayerController.networkUrl(Uri.parse(
              artists!.videoLinkData![0].videoLink!))
            ..initialize().then((_) {
              _videoController!.play();
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
        }
      }

    getOdooInstance().then((odoo) {
      _refresh();
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if(_youtubePlayerController != null)
      {
        _youtubePlayerController!.pause();
      }
    super.deactivate();
  }

  @override
  void dispose() {
    if(_videoController != null) {
      _videoController!.dispose();
    }
    if(_youtubePlayerController != null)
    {
      _youtubePlayerController!.dispose();
      _idController.dispose();
      _seekToController.dispose();
    }
    super.dispose();
  }

  Future<void> _refresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 0), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _attachmentsList.clear();
      categoryDisplay = "";
      tagDisplay = "";
      fetchDetails();
      print("Loaded artist: ${artists?.name}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
      FloatingActionButton.extended(
        tooltip: 'Call',
        heroTag: 'call',
        icon: const Icon(Icons.call),
        label: Text('Call', style: poppinsBold),
        onPressed: () {
          launchCall(getCompanyMobile());
        },
      )
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_youtubePlayerController!.value.isFullScreen) {
      setState(() {
        _playerState = _youtubePlayerController!.value.playerState;
        _videoMetaData = _youtubePlayerController!.metadata;
      });
    }
  }

  RefreshIndicator body(BuildContext context) {

    final attachmentImagesView =

    // SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     child: Wrap(
    //         alignment: WrapAlignment.spaceBetween,
    //         spacing: 10,
    //         runSpacing: 10,
    //         direction: Axis.horizontal,
    //         children:
    //         _attachmentsList.take(6).map((item) {
    //           return
    //             // Container(
    //             //   padding: EdgeInsets.only(
    //             //       top: 5.sp, bottom: 5.sp, left: 5.sp, right: 5.sp),
    //             //   child: Card(
    //             //     color: ThemeService().getDarkTheme() ? Colors.black : null,
    //             //     shape: RoundedRectangleBorder(
    //             //         borderRadius: BorderRadius.circular(10.r)),
    //             //     elevation: 10.0,
    //             //     child:
    //
    //                 InkWell(
    //                     onTap: () {
    //                       if (item.mimetype!.contains("image")) {
    //                         List<String> imageList = [];
    //                         for (int i = 0; i < _attachmentsList.length; i++) {
    //                           if (_attachmentsList[i]
    //                               .mimetype!
    //                               .contains("image")) {
    //                             imageList.add(
    //                                 _attachmentsList[i].url!);
    //                           }
    //                         }
    //                         push(GalleryPhotoViewWrapper(
    //                           galleryItems: imageList,
    //                           backgroundDecoration: const BoxDecoration(
    //                             color: Colors.black,
    //                           ),
    //                           initialIndex: _attachmentsList.indexOf(item),
    //                           scrollDirection: Axis.horizontal,
    //                         ));
    //                       } else {
    //                         launchURL(item.url!);
    //                       }
    //                     },
    //                     borderRadius: BorderRadius.circular(10.r),
    //                     child: Container(
    //                         padding: EdgeInsets.only(
    //                             top: 5.sp,
    //                             bottom: 5.sp,
    //                             left: 5.sp,
    //                             right: 5.sp),
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: <Widget>[
    //                             item.url! != "" &&
    //                                 item.mimetype!.contains("image")
    //                                 ? SizedBox(
    //                               height: 120.h,
    //                               width: 100.w,
    //                               child: CachedNetworkImage(
    //                                 imageUrl: item.url!,
    //                                 placeholder: (context, url) =>
    //                                 const CircularProgressIndicator(),
    //                                 errorWidget: (context, url, error) =>
    //                                     Image.asset(Images.logo),
    //                                 fit: BoxFit.cover,
    //                               ),
    //                             )
    //                                 : SizedBox(
    //                                 height: 120.h,
    //                                 width: 100.w,
    //                                 child:
    //                                 Image.asset(
    //                                   Images.icInsertDriveFileBlack,
    //                                   color: ColorConstants.colorPrimary,
    //                                   height: 50.h,
    //                                   width: 50.w,
    //                                 ))
    //                           ],
    //                         )))
    //               //   ,
    //               // ))
    //           ;
    //         }).toList()))
    ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 3,
              // itemCount: category.categoryList.length,
              padding: EdgeInsets.all(10.sp),
              physics: const ScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              // childAspectRatio: (itemWidth / itemHeight),
              childAspectRatio: 0.7,
              shrinkWrap: true,
              children: List.generate(
                  _attachmentsList.length > 6 ? 6: _attachmentsList.length, (index) {
                Attachments item = _attachmentsList[index];
                return
                  InkWell(
                      onTap: () {
                        if (item.mimetype!.contains("image")) {
                          List<String> imageList = [];
                          for (int i = 0; i < _attachmentsList.length; i++) {
                            if (_attachmentsList[i]
                                .mimetype!
                                .contains("image")) {
                              imageList.add(
                                  _attachmentsList[i].url!);
                            }
                          }
                          push(GalleryPhotoViewWrapper(
                            galleryItems: imageList,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            initialIndex: _attachmentsList.indexOf(item),
                            scrollDirection: Axis.horizontal,
                          ));
                        } else {
                          launchURL(item.url!);
                        }
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                          padding: EdgeInsets.only(
                              top: 5.sp,
                              bottom: 5.sp,
                              left: 5.sp,
                              right: 5.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              item.url! != "" &&
                                  item.mimetype!.contains("image")
                                  ? SizedBox(
                                height: 120.h,
                                width: 100.w,
                                child: CachedNetworkImage(
                                  imageUrl: item.url!,
                                  // placeholder: (context, url) => const CircularProgressIndicator(),
                                  placeholder: (context, url) =>
                                      Image.asset(Images.logo,
                                        fit: BoxFit.cover,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(Images.logo),
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : SizedBox(
                                  height: 120.h,
                                  width: 100.w,
                                  child:
                                  Image.asset(
                                    Images.icInsertDriveFileBlack,
                                    color: ColorConstants.colorPrimary,
                                    height: 50.h,
                                    width: 50.w,
                                  ))
                            ],
                          )));
              }),
            )
          ],
        )
      ],
    );


    return RefreshIndicator(
      onRefresh: _refresh,
      child: Stack(children: [
        CardSliverAppBar(
          height: 240.h,
          background:
          CachedNetworkImage(
            imageUrl: artists!.backgroundImage!,
            // imageBuilder: (context, imageProvider) => Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: imageProvider,
            //         fit: BoxFit.fill,
            //         colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
            //   ),
            // ),
            // placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              Images.logo,
              fit: BoxFit.fill,
            ),
            // placeholder: (context, url) => Image.asset(
            //   Images.logo,
            //   fit: BoxFit.fitWidth,
            // ),
            fit: BoxFit.fill,
          ),
          title: Text(artists!.name!, style: textBold20px),
          titleDescription: Text("$categoryDisplay | ${artists!.artistCity!}",
              style: textBold12px),
          card: CachedNetworkImage(
            imageUrl: artists!.image!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              Images.logo,
              fit: BoxFit.fitHeight,
            ),
            fit: BoxFit.fill,
          ),
          backButton: true,
          // backButtonColors: [ThemeService().getDarkTheme() ? Colors.black :Colors.black, Colors.black],
          action: IconButton(
            onPressed: () {
              addRemoveFavorites();
            },
            icon: artists!.isFavorite!
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            color: Colors.red,
            iconSize: 30.sp,
          ),
          body: Container(
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text("Category", style: textBold16px),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text(categoryDisplay, style: textRegular16px),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text("City", style: textBold16px),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text(artists!.artistCity!, style: textRegular16px),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text("Tags", style: textBold16px),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text(tagDisplay, style: textRegular16px),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text("Budgets", style: textBold16px),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text('Private Price',
                                  textAlign: TextAlign.center,
                                  style: poppinsBold)),
                          Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(
                                  "${getCurrencySymbol(artists!.currencyId?.name ?? "")} ${Base.dp(artists!.privatePrice!, 2)}",
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular)),
                        ]),
                        TableRow(children: [
                          Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text('Corporate Price',
                                  textAlign: TextAlign.center,
                                  style: poppinsBold)),
                          Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(
                                  "${getCurrencySymbol(artists!.currencyId?.name ?? "")} ${Base.dp(artists!.corporatePrice!, 2)}",
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular)),
                        ]),
                      ],
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Text("Biography", style: textBold16px),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: InkWell(
                      // onTap: () {
                      //   setState(() {
                      //     expandText = !expandText;
                      //   });
                      // },
                      child: Html(
                    data: artists!.description!,
                    style: {
                      "body": Style(
                          fontSize: FontSize(14.sp),
                          fontFamily: fontNameRegular),
                    },
                  )),
                ),
                artists!.videoLinkData!.isNotEmpty && artists!.videoLinkData![0].videoLink != "" ?
                SizedBox(
                  height: 20.h,
                ) : const SizedBox(),

                artists!.videoLinkData!.isNotEmpty && artists!.videoLinkData![0].videoLink != "" ?
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Promotion Video", style: textBold16px),

                      InkWell(
                          onTap: () {
                            if (artists!.videoLinkData != null && artists!.videoLinkData![0].videoLink!.contains('youtube') || artists!.videoLinkData![0].videoLink!.contains('youtu.be'))
                              {
                                launchURL(artists!.videoLinkData![0].videoLink!);
                              }
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
                ) : const SizedBox(),

                artists!.videoLinkData!.isNotEmpty && artists!.videoLinkData![0].videoLink != "" ?
                InkWell(
                  onTap: () {
                    // launchURL(artists!.videoLink!);
                  },
                  child:
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
                            artists!.videoLinkData!.isNotEmpty && artists!.videoLinkData![0].videoLink != "" ? artists!.videoLinkData![0].videoLink!.contains('youtube') || artists!.videoLinkData![0].videoLink!.contains('youtu.be') ?

                            // YoutubePlayer(
                            //   controller: _youtubePlayerController,
                            //   showVideoProgressIndicator: true,
                            //   progressIndicatorColor: Colors.amber,
                            //   progressColors: const ProgressBarColors(
                            //     playedColor: Colors.amber,
                            //     handleColor: Colors.amberAccent,
                            //   ),
                            //   onReady: () {
                            //     _youtubePlayerController.addListener(listener);
                            //   },
                            // )
                            YoutubePlayerBuilder(
                              onExitFullScreen: () {
                                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                              },
                              player: YoutubePlayer(
                                controller: _youtubePlayerController!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.blueAccent,
                                topActions: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      _youtubePlayerController!.metadata.title,
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
                                onReady: () {
                                  _isPlayerReady = true;
                                },
                                onEnded: (data) {
                                  _youtubePlayerController!
                                      .load(videoId!);
                                  // _showSnackBar('Next Video Started!');
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
                                  // actions: [
                                  //   IconButton(
                                  //     icon: const Icon(Icons.video_library),
                                  //     onPressed: () => Navigator.push(
                                  //       context,
                                  //       CupertinoPageRoute(
                                  //         builder: (context) => VideoList(),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ],
                                ),
                                body: ListView(
                                  children: [
                                    player,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          _space,
                                          _text('Title', _videoMetaData.title),
                                          _space,
                                          _text('Channel', _videoMetaData.author),
                                          _space,
                                          _text('Video Id', _videoMetaData.videoId),
                                          _space,
                                          Row(
                                            children: [
                                              _text(
                                                'Playback Quality',
                                                _youtubePlayerController!.value.playbackQuality ?? '',
                                              ),
                                              const Spacer(),
                                              _text(
                                                'Playback Rate',
                                                '${_youtubePlayerController!.value.playbackRate}x  ',
                                              ),
                                            ],
                                          ),
                                          _space,
                                          TextField(
                                            enabled: _isPlayerReady,
                                            controller: _idController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter youtube \<video id\> or \<link\>',
                                              fillColor: Colors.blueAccent.withAlpha(20),
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.blueAccent,
                                              ),
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () => _idController.clear(),
                                              ),
                                            ),
                                          ),
                                          _space,
                                          Row(
                                            children: [
                                              _loadCueButton('LOAD'),
                                              const SizedBox(width: 10.0),
                                              _loadCueButton('CUE'),
                                            ],
                                          ),
                                          _space,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.skip_previous),
                                                onPressed: _isPlayerReady
                                                    ? () => _youtubePlayerController!.load(videoId!)
                                                    : null,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  _youtubePlayerController!.value.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                ),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                  _youtubePlayerController!.value.isPlaying
                                                      ? _youtubePlayerController!.pause()
                                                      : _youtubePlayerController!.play();
                                                  setState(() {});
                                                }
                                                    : null,
                                              ),
                                              IconButton(
                                                icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                  _muted
                                                      ? _youtubePlayerController!.unMute()
                                                      : _youtubePlayerController!.mute();
                                                  setState(() {
                                                    _muted = !_muted;
                                                  });
                                                }
                                                    : null,
                                              ),
                                              FullScreenButton(
                                                controller: _youtubePlayerController,
                                                color: Colors.blueAccent,
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.skip_next),
                                                onPressed: _isPlayerReady
                                                    ? () => _youtubePlayerController!.load(videoId!)
                                                    : null,
                                              ),
                                            ],
                                          ),
                                          _space,
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                "Volume",
                                                style: TextStyle(fontWeight: FontWeight.w300),
                                              ),
                                              Expanded(
                                                child: Slider(
                                                  inactiveColor: Colors.transparent,
                                                  value: _volume,
                                                  min: 0.0,
                                                  max: 100.0,
                                                  divisions: 10,
                                                  label: '${(_volume).round()}',
                                                  onChanged: _isPlayerReady
                                                      ? (value) {
                                                    setState(() {
                                                      _volume = value;
                                                    });
                                                    _youtubePlayerController!.setVolume(_volume.round());
                                                  }
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          _space,
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 800),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color: _getStateColor(_playerState),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _playerState.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                :

                            VideoPlayer(_videoController!) : const SizedBox()
                            // WebViewWidget(
                            //   controller: _controller
                            //     ..loadRequest(Uri.parse(artists!.videoLink!)),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ): const SizedBox(),

                SizedBox(height: 20.h,),

                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Images", style: textBold18px),


                        InkWell(
                            onTap: () {
                              Get.to(() => ImagesListScreen(attachmentsList: _attachmentsList,artists: artists,), transition: Transition.downToUp);
                            },
                            child:
                            Row(
                              children: [
                                Text(
                                  "View More",
                                  style: poppinsBold.copyWith(
                                      color: ThemeService().getDarkTheme()
                                          ? Colors.white
                                          : ColorConstants.android_red_dark),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 10.h,),

                attachmentImagesView,

                artists!.videoLinkData != null && artists!.videoLinkData!.length > 1 ?
                SizedBox(height: 20.h,) : const SizedBox(),

                artists!.videoLinkData != null && artists!.videoLinkData!.length > 1 ?
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("More Videos", style: textBold18px),
                      InkWell(
                          onTap: () {
                            Get.to(() => VideosListScreen(artists: artists,), transition: Transition.downToUp);
                          },
                          child:
                          Row(
                            children: [
                              Text(
                                "View More",
                                style: poppinsBold.copyWith(
                                    color: ThemeService().getDarkTheme()
                                        ? Colors.white
                                        : ColorConstants.android_red_dark),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ): const SizedBox(),

            artists!.videoLinkData != null && artists!.videoLinkData!.length > 1 ?
                    Column(
                      children: [
                        SizedBox(height: 10.h,),

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
                                    artists!.videoLinkData![1].videoLink!.contains('youtube') || artists!.videoLinkData![1].videoLink!.contains('youtu.be') ?
                                    YoutubePlayerBuilder(
                                      onExitFullScreen: () {
                                        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                                      },
                                      player: YoutubePlayer(
                                        controller: artists!.videoLinkData![1].youtubePlayerController!,
                                        showVideoProgressIndicator: true,
                                        progressIndicatorColor: Colors.blueAccent,
                                        topActions: <Widget>[
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Text(
                                              artists!.videoLinkData![1].youtubePlayerController!.metadata.title,
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
                                          artists!.videoLinkData![1].youtubePlayerController!.load(artists!.videoLinkData![1].videoId!);
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
                                    VideoPlayer(artists!.videoLinkData![1].videoController!)
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
                                      launchURL(artists!.videoLinkData![1].videoLink!);
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
                    )
                     : const SizedBox(),


                SizedBox(height: 100.h,)
              ],
            ),
          ),
        )
      ]),
      // )
    );
  }

  fetchDetails() {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> values = {};
        if (widget.artists != null) {
          values["product_id"] = [widget.artists!.id];
        }
        values["partner_id"] = getUser()!.partnerId;
        await odoo.callShowArtists(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              isLoading = false;
              for (var record in res.getResult()["product_details"]) {
                artists = Artists.fromJson(record, getURL(), getSession());
              }
              for (var category in artists!.productCategoryData!) {
                if (categoryDisplay != "") {
                  categoryDisplay += " ,${category.name!.trimLeft()}";
                } else {
                  categoryDisplay = category.name!.trimLeft();
                }
              }
              for (var tag in artists!.productTagData!) {
                if (tagDisplay != "") {
                  tagDisplay += " ,${tag.name!.trimLeft()}";
                } else {
                  tagDisplay = tag.name!.trimLeft();
                }
              }
            });
            _getAttachments();
          } else {
            setState(() {
              isLoading = false;
            });
            showMessage("Warning", res.getErrorMessage());
          }
        });
      }
    });
  }

  addRemoveFavorites() {
    Map<String, dynamic> values = {};
    values["partner_id"] = getUser()!.partnerId;
    values["product_id"] = artists!.id;
    values["is_favorite"] = artists!.isFavorite;
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        odoo.addRemoveFavorites(
            values
        ).then((OdooResponse res) {
          if (!res.hasError()) {
            if (res.getResult()["status"] == true)
            {
              showData();
              showCustomSnackBar(res.getResult()["message"],context);
              // artists!.isFavorite = !artists!.isFavorite!;
              // setState(() {
              // });
            }
            else
            {
              showMessage("Alert", res.getResult()["message"]);
            }
          } else {
            showMessage("Error", res.getErrorMessage());
          }
        });
      }
    });
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
          if (_idController.text.isNotEmpty) {
            var id = YoutubePlayer.convertUrlToId(
              _idController.text,
            ) ??
                '';
            if (action == 'LOAD') _youtubePlayerController!.load(id);
            if (action == 'CUE') _youtubePlayerController!.cue(id);
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            _showSnackBar('Source can\'t be empty!');
          }
        }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  showData() async {
    Map<String, dynamic> values = {};
    values["partner_id"] = getUser()!.partnerId;
    values["product_id"] = artists!.id!;
    await odoo.callShowArtists(values).then((OdooResponse res) async {
      if (!res.hasError()) {
          for (var record in res.getResult()["product_details"]) {
            artists = Artists.fromJson(record, getURL(), getSession());
          }
          setState(() {
        });
      } else {
        showMessage("Warning", res.getErrorMessage());
      }
    });
  }

  _getAttachments() {
    _attachmentsList.clear();
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {};
        values["res_model"] = Strings.product_product;
        values["res_id"] = artists!.id!;
        await odoo.showAttachments(values).then((OdooResponse res) async {
          if (!res.hasError()) {
              _attachmentsList.add(Attachments(url:artists!.image!, name: "Profile", mimetype: "image"));
              for (var i in res.getResult()["attachment_details"]) {
                Attachments attachments = Attachments.fromJson(i,getURL(), getSession());
                _attachmentsList.add(attachments);
              }
              setState(() {
            });
          } else {
            showMessage("Warning", res.getErrorMessage());
          }
        });
      }
    });
  }
}
