import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/base.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SearchDropDown extends StatefulWidget {
  final dynamic list;
  final ValueChanged<dynamic>? onChanged;
  final dynamic selectItem;
  final bool? isMultiSelection;

  const SearchDropDown(
      {super.key,
        this.list,
        this.onChanged, this.selectItem,
        this.isMultiSelection = false,
      });

  @override
  SearchDropDownState createState() => SearchDropDownState();
}

class SearchDropDownState extends Base<SearchDropDown> {
  final _editTextController = TextEditingController(text: '',);

  @override
  Widget build(BuildContext context) {
    return
      widget.isMultiSelection! ?
      DropdownSearch<dynamic>.multiSelection(
        itemAsString: (item) => item.name!,
        filterFn: (title, filter) => title.name.toLowerCase().toString().contains(filter.toLowerCase()),
        selectedItems: widget.selectItem,
        items: (filter, t) => widget.list,
        // asyncItems: (String? filter) async => widget.list,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.w))
          ),
        ),
        dropdownBuilder: customDropDownExampleMultiSelection,
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          title:
          InkWell(
              onTap: ()
              {
                Navigator.pop(context);
              },
              child:
              Container(
                padding: EdgeInsets.only(right:20.sp, top: 10.sp),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Close", style: textBoldRed16px)
                  ],
                ),
              )
          ),
          showSelectedItems: true,
          itemBuilder: customPopupItem,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            padding: EdgeInsets.all(10.sp),
            controller: _editTextController,
            decoration: InputDecoration(
              hintText: "Search Item",
              hintStyle: textRegularGrey12px,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search), onPressed: () {  },
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _editTextController.clear();
                },
              ),
            ),
          ),
        ),
        // compareFn: (item, sItem) => item.name == sItem.name,
        compareFn: (item, sItem){
          if(item != null)
          {
            return item.id == sItem.id;
          }
          return false;
        },
        onChanged: (v) {
          _editTextController.text = "";
          widget.onChanged!(v);
        },
      )

          :

      DropdownSearch<dynamic>(
        itemAsString: (item) => item.name!,
        filterFn: (title, filter) => title.name.toLowerCase().toString().contains(filter.toLowerCase()),
        selectedItem: widget.selectItem,
        items: (filter, t) => widget.list,
        // asyncItems: (String? filter) async => widget.list,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.w))
          ),
        ),
        // dropdownDecoratorProps: DropDownDecoratorProps(
        //   dropdownSearchDecoration: InputDecoration(
        //     // contentPadding: const EdgeInsets.all(0),
        //     // hintText: 'Parent Property',
        //     // hintStyle: ThemeService().getDarkTheme() ? textRegularWhite : poppinsRegular,
        //   ),
        // ),
        dropdownBuilder: customDropDownPrograms,
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          showSelectedItems: true,
          itemBuilder: customPopupItem,
          showSearchBox: true,
          title:
          InkWell(
              onTap: ()
              {
                Navigator.pop(context);
              },
              child:
              Container(
                padding: EdgeInsets.only(right:20.sp, top: 10.sp),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Close", style: textBoldRed16px,)
                  ],
                ),
              )

          ),

          searchFieldProps: TextFieldProps(
            padding: EdgeInsets.all(10.sp),
            controller: _editTextController,
            decoration: InputDecoration(
              hintText: "Search Item",
              prefixIcon: IconButton(
                icon: const Icon(Icons.search), onPressed: () {  },
              ),
              hintStyle: textRegularGrey12px,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _editTextController.clear();
                },
              ),
            ),
          ),
        ),
        // compareFn: (item, sItem) => item.name == sItem.name,
        compareFn: (item, sItem){
          if(item != null)
          {
            return item.id == sItem.id;
          }
          return false;
        },
        onChanged: (v) {
          _editTextController.text = "";
          widget.onChanged!(v);
        },
      )
    ;
  }
}
