
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/models/company.dart';
import 'package:my_artist_demo/app/models/partners.dart';
import 'package:my_artist_demo/app/screens/artists/home_fragment.dart';
import 'package:my_artist_demo/app/screens/menu/menu_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/screens/artists/favorites_artists_list_screen.dart';
import 'package:my_artist_demo/app/widgets/fab_bottom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

class Home extends StatefulWidget {
  final int? navigatePosition;

  const Home({super.key, this.navigatePosition});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends Base<Home> {
  bool? isRefresh;
  int _selectedDrawerIndex = 0;
  List<FABBottomAppBarItem> fabItems = [];
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOdooInstance().then((odoo) {
        getGroups();
        setState(() {

          fabItems.add(FABBottomAppBarItem(iconData: Images.receiveBid, text: 'Artists'));
          fabItems.add(FABBottomAppBarItem(iconData: Images.transaction, text: 'Bookings'));
          fabItems.add(FABBottomAppBarItem(iconData: Images.receiveBid, text: 'Favorites'));
          fabItems.add(FABBottomAppBarItem(iconData: Images.settings, text: 'Menu'));
          isLoad = true;
        });
        _getProfileData();
      });
    });
  }

  void _getProfileData() {
    odoo.searchRead(
      Strings.res_partner,
      [["id", "=", getUser()?.partnerId]],
      Partners.fields,
    ).then((OdooResponse res) async {
      if (!res.hasError()) {
        final results = res.getResult();
        if (results.isEmpty) {
          print("No partner data found");
          return;
        }

        final result = results[0];
        String imageURL =
            "${getURL()}/web/content?model=${Strings.res_partner}&id=${result['id']}&field=image_1920&${getSession()}";

        Partners partners = Partners.fromJson(result, imageURL);

        if (partners.mobile != null) {
          setPartnerMobile(partners.mobile!);
        }

        Map<String, dynamic> values = {"company_id": getUser()?.companyId};

        await odoo.showCompany(values).then((OdooResponse res) {
          if (!res.hasError()) {
            final companyDetails = res.getResult()["company_details"];
            if (companyDetails != null) {
              for (var record in companyDetails) {
                Company company = Company.fromJson(record);
                setCurrencyDetails(company.currencyId?.id ?? 0, company.currencyId?.name ?? "");
                if (company.phone != null) setCompanyMobile(company.phone!);
                if (company.email != null) setCompanyEmail(company.email!);
              }
            }
          }
        });

        if (widget.navigatePosition != null) {
          _selectedTab(widget.navigatePosition!);
        } else {
          _selectedTab(_selectedDrawerIndex);
        }
      } else {
        showMessage("Warning", res.getErrorMessage());
      }
    });
  }

  Widget _selectedTab(int pos) {
    setState(() {
      _onSelectItem(pos);
      isRefresh = true;
    });
    switch (pos) {
      case 0:
        return const HomeFragment(key: PageStorageKey(0));
      case 1:
        return const MenuScreen(key: PageStorageKey(1));
      case 2:
        return const FavoritesArtistsListScreen(key: PageStorageKey(2));
      case 3:
        return MenuScreen(key: const PageStorageKey(3), homeState: this);
      default:
        return const Text("Invalid screen requested");
    }
  }

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
  }

  void refreshDarkTheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(fabItems.length, (int index) {
      Color? color = _selectedDrawerIndex == index
          ? ColorConstants.redDark
          : Colors.grey[700];

      return Expanded(
        child: InkWell(
          onTap: () {
            _selectedTab(index);
            setState(() {
              _selectedDrawerIndex = index;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                fabItems[index].iconData!,
                height: 22.h,
                width: 22.w,
                color: color,
              ),
              SizedBox(height: 4.h),
              Text(
                fabItems[index].text!,
                style: poppinsBold.copyWith(color: color, fontSize: 12.sp),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    });

    return WillPopScope(
      onWillPop: () async {
        if (_selectedDrawerIndex != 0) {
          _selectedTab(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ThemeService().getDarkTheme()
            ? Colors.black
            : ColorConstants.bgColor,
        body: isLoad
            ? Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: _selectedTab(_selectedDrawerIndex),
        )
            : const SizedBox(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: ThemeService().getDarkTheme() ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 6,
              )
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
