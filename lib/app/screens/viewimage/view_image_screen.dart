import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart' hide LoadingBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/screens/viewimage/gallery_example_item.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/base.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImageScreen extends StatefulWidget {
  final List<String>? imageList;

  const ViewImageScreen({super.key,this.imageList});

  @override
  ViewImageScreenState createState() => ViewImageScreenState();
}

class ViewImageScreenState extends Base<ViewImageScreen> {
  @override
  void initState() {
    super.initState();
    getOdooInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SafeArea(
        child:
        Stack
          (
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: ()
                    {
                      Navigator.pop(context);
                    },
                  child:
                  Padding(padding: EdgeInsets.all(10.sp),
                    child:
                    Image.asset(Images.cancel, width: 45.w, height: 45.h)
                    ,)
                )
              ],
            ),

            Center(
              child:
              widget.imageList!.length == 1 ?
              GalleryPhotoViewWrapper(
                galleryItems: widget.imageList!,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                initialIndex: 0,
                scrollDirection: Axis.horizontal,
              )
                  :
              SizedBox(
                  height: 200.h,
                  child:
                  ListView.builder(
                    itemCount:
                    widget.imageList!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10.sp),
                    itemBuilder: (context, index) {
                      return
                        GalleryExampleItemThumbnail(
                          url: widget.imageList![index],
                          onTap: () {
                            open(context, index,widget.imageList);
                          },
                        );
                    },
                  )
              )
            )
          ],
        ))

    );
  }
  void open(BuildContext context, int index, List<String>? productImagesList) {
    push(GalleryPhotoViewWrapper(
          galleryItems: productImagesList!,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child:
        SafeArea(
        child:
        Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: ()
                    {
                      Navigator.pop(context);
                    },
                    child:
                    Padding(padding: EdgeInsets.all(10.sp),
                      child:
                      Image.asset(Images.cancel, width: 45.w, height: 45.h)
                      ,)
                )
              ],
            ),

          ],
        )),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(item,
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}