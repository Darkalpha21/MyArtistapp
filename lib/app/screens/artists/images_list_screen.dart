import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/attachments.dart';
import 'package:my_artist_demo/app/screens/viewimage/view_image_screen.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';


class ImagesListScreen extends StatefulWidget {

  final List<Attachments>? attachmentsList;
  final Artists? artists;

  const ImagesListScreen({super.key, this.attachmentsList, this.artists});

  @override
  State<StatefulWidget> createState() {
    return ImagesListScreenState();
  }
}

class ImagesListScreenState extends Base<ImagesListScreen> {
  List<Attachments> _attachmentsList = [];

  @override
  void initState() {
    super.initState();
    _attachmentsList = widget.attachmentsList!;
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
                  GridView.count(
                    crossAxisCount: 3,
                    // itemCount: category.categoryList.length,
                    padding: EdgeInsets.all(10.sp),
                    physics: const NeverScrollableScrollPhysics(),
                    // scrollDirection: Axis.horizontal,
                    // childAspectRatio: (itemWidth / itemHeight),
                    childAspectRatio: 0.7,
                    shrinkWrap: true,
                    children: List.generate(
                        _attachmentsList.length, (index) {
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
                                        placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
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
          )


      ),
   ]) );
  }

}
