import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/utility/images.dart';

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    super.key,
    required this.url,
    required this.onTap,
  });

  final String url;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: url,
          child:
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: url,
              errorWidget: (context, url, error) =>
                  Image.asset(Images.logo),
              fit: BoxFit.cover,
              height: 120.h,
              width: 120.w,
            ),
          )
          // Image.asset(url, height: 80.0)
        ),
      ),
    );
  }
}