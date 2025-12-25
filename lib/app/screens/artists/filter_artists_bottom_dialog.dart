
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/models/filter_artists.dart';
import 'package:my_artist_demo/app/models/tags.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/decimal_textInput_formatter.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_text_input_field.dart';
import 'package:my_artist_demo/app/widgets/search_dropdown.dart';
import 'package:my_artist_demo/base.dart';


class FilterArtistsBottomDialogScreen extends StatefulWidget {
  final FilterArtists? filterArtists;
  final ValueChanged<FilterArtists>? onTap;
  /*
 if 1 = BidStates.getAllData()
if 2 = BidStates.getReceiveData()
if 3 = BidStates.getTransactionData()
if 4 = not show status
   */
  const FilterArtistsBottomDialogScreen({super.key,  this.filterArtists, this.onTap});

  @override
  FilterArtistsBottomDialogScreenState createState() =>
      FilterArtistsBottomDialogScreenState();
}

class FilterArtistsBottomDialogScreenState
    extends Base<FilterArtistsBottomDialogScreen> {
  FilterArtists? filterArtists;
  List<Category> talentsList = [];
  List<Category> selectTalents = [];
  List<Tags> tagsList = [];
  List<Tags> selectTags = [];
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.filterArtists != null)
      {
        filterArtists = widget.filterArtists;
        // if(filterBids!.planedStartDate != null)
        // {
        //   _startDateController.text = filterBids!.planedStartDate!;
        // }
        // if(filterBids!.planedEndDate != null)
        // {
        //   _endDateController.text = filterBids!.planedEndDate!;
        // }
        if(filterArtists!.city != null)
        {
          _cityController.text = filterArtists!.city!;
        }
        if(filterArtists!.minPrice != null)
        {
          _minPriceController.text = filterArtists!.minPrice.toString();
        }
        if(filterArtists!.maxPrice != null)
        {
          _maxPriceController.text = filterArtists!.maxPrice.toString();
        }
        selectTalents.clear();
        for(int i=0; i < filterArtists!.talent!.length; i++)
        {
          selectTalents.add(filterArtists!.talent![i]);
        }
        selectTags = [];
        for(int i=0; i < filterArtists!.tags!.length; i++)
        {
          selectTags.add(filterArtists!.tags![i]);
        }
      }
    getOdooInstance();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getTalents();
    });
  }

  _getTalents() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> values = {};
    talentsList = [];
    odoo.callShowTalents(values).then((OdooResponse res) async {
      if (!res.hasError()) {
        for (var record in res.getResult()["category_details"]) {
          Category products = Category.fromJson(record, getURL(), getSession());
          talentsList.add(products);
        }
        setState(() {
        });
        _getTags();
      } else {
        setState(() {
          isLoading = false;
        });
        showMessage("Warning", res.getErrorMessage());
      }
    });
  }

  _getTags() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> values = {};
    tagsList = [];
    odoo.callShowTags(values).then((OdooResponse res) async {
      if (!res.hasError()) {
        isLoading = false;
        for (var record in res.getResult()["tag_details"]) {
          Tags warehouses = Tags.fromJson(record,getURL(), getSession());
          tagsList.add(warehouses);
        }
        setState(() {});
      } else {
        setState(() {
          isLoading = false;
        });
        showMessage("Warning", res.getErrorMessage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.3,
        initialChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
              // height: height,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: ThemeService().getDarkTheme()
                    ? ColorConstants.black
                    : Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    topLeft: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                            Navigator.pop(context);
                        },
                        child: Text('Close', style: textBoldRed18px),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(child:
                      Text('Filter', style: textBold18px)),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _cityController.text = "";
                            _minPriceController.text = "";
                            _maxPriceController.text = "";
                            selectTalents = [];
                            selectTags = [];
                          });
                        },
                        child: Text('Clear all', style: textBoldBlue16px),
                      )
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            ThemeService().getDarkTheme() ? null : Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.r),
                            topLeft: Radius.circular(20.r)),
                      ),
                      padding: EdgeInsets.all(10.sp),
                      alignment: Alignment.center,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('City', style: textBold16px),
                            SizedBox(
                              height: 5.h,
                            ),
                            CustomTextInputField(
                                hintText: 'City',
                                controller: _cityController),
                            SizedBox(
                              height: 10.h,
                            ),

                            Text('Price Range', style: textBold16px),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Min', style: poppinsRegular),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        CustomTextInputField(
                                            hintText: '0',
                                            controller: _minPriceController,
                                            inputType: const TextInputType
                                                .numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              DecimalTextInputFormatter(),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]')),
                                              LengthLimitingTextInputFormatter(10),
                                            ]),
                                      ],
                                    )),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Max', style: poppinsRegular),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        CustomTextInputField(
                                            hintText: '1000000',
                                            controller: _maxPriceController,
                                            inputType: const TextInputType
                                                .numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              DecimalTextInputFormatter(),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]')),
                                              LengthLimitingTextInputFormatter(10),
                                            ]),
                                      ],
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),



                            Text('Talents', style: textBold16px),
                            SearchDropDown(
                              list: talentsList,
                              isMultiSelection: true,
                              selectItem: selectTalents,
                              onChanged: (v) {
                                setState(() {
                                  selectTalents = List<Category>.from(v);
                                });
                              },
                            ),
                         
                            SizedBox(
                              height: 10.h,
                            ),

                            Text('Tags', style: textBold16px),
                            SearchDropDown(
                              list: tagsList,
                              isMultiSelection: true,
                              selectItem: selectTags,
                              onChanged: (v) {
                                setState(() {
                                  selectTags = List<Tags>.from(v);
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            
                          ]),
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16.sp),
                    child: ElevatedButton(
                      onPressed: () {
                        filterArtists = FilterArtists();
                        if(_cityController.text.isNotEmpty)
                        {
                          filterArtists!.city = _cityController.text;
                        }
                        if(_minPriceController.text.isNotEmpty)
                        {
                          filterArtists!.minPrice = double.parse(_minPriceController.text);
                        }
                        if(_maxPriceController.text.isNotEmpty)
                        {
                          filterArtists!.maxPrice = double.parse(_maxPriceController.text);
                        }
                        filterArtists!.talent = [];
                        if(selectTalents.isNotEmpty)
                        {
                          for(int i=0; i < selectTalents.length; i++)
                          {
                            filterArtists!.talent!.add(selectTalents[i]);
                          }
                        }
                        filterArtists!.tags = [];
                        if(selectTags.isNotEmpty)
                        {
                          for(int i=0; i < selectTags.length; i++)
                          {
                            filterArtists!.tags!.add(selectTags[i]);
                          }
                        }
                        widget.onTap!(filterArtists!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeService().getDarkTheme()
                            ? Colors.white
                            : ColorConstants.appGreen,
                        padding: EdgeInsets.all(12.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text('Apply Filter',
                          style: ThemeService().getDarkTheme()
                              ? textBoldGreen18px
                              : textBoldWhite18px),
                    ),
                  )
                ],
              ));
        });
  }

}
