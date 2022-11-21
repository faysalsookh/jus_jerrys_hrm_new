import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/custom_widgets/custom_buttom.dart';
import 'package:hrm_app/data/model/response_all_user.dart';
import 'package:hrm_app/screens/appFlow/home/appreciate_teammate/apreciate_teamate_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/office_tab/edit_official_info/designation_list/designation_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

class MultiSelectEmployee extends StatefulWidget {
  const MultiSelectEmployee({Key? key}) : super(key: key);

  @override
  State<MultiSelectEmployee> createState() => _MultiSelectEmployeeState();
}

class _MultiSelectEmployeeState extends State<MultiSelectEmployee> {
  HashSet<User> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;
  List<int> userIds = [];
  List<String> userNames = [];

  @override
  Widget build(BuildContext context) {
    final designationProvider = context.watch<DesignationProvider>();
    final allUserProvider = context.watch<AppreciateTeammateProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: isMultiSelectionEnabled
            ? IconButton(
                onPressed: () {
                  selectedItem.clear();
                  isMultiSelectionEnabled = false;
                  setState(() {});
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ))
            : null,
        title:  Text(tr("select_employee")),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: TextField(
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: tr("search"),
                    filled: true,
                    contentPadding: const EdgeInsets.all(0),
                    border: const  OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                  ),
                  controller: allUserProvider.searchUserData,
                  onChanged: allUserProvider.textChanged,
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(tr('long_press_to_select_employee'),style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: AppColors.colorDeepRed),),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 10,
                    children: List<Widget>.generate(
                      designationProvider
                              .designationList?.data?.designations?.length ??
                          0,
                      (int index) {
                        return ChoiceChip(
                          elevation: 3,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(designationProvider.designationList
                                    ?.data?.designations?[index].title ??
                                ""),
                          ),
                          selected: allUserProvider.value == index,
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF5DB226),
                          labelStyle: TextStyle(
                            color: allUserProvider.value == index
                                ? Colors.white
                                : const Color(0xFF5DB226),
                          ),
                          onSelected: (bool selected) {
                            allUserProvider.onSelected(
                                selected,
                                index,
                                designationProvider.designationList?.data
                                    ?.designations?[index].id);
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      allUserProvider.responseAllUser?.data?.users?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        doMultiSelection(allUserProvider
                            .responseAllUser!.data!.users![index]);
                      },
                      onLongPress: () {
                        isMultiSelectionEnabled = true;
                        doMultiSelection(allUserProvider
                            .responseAllUser!.data!.users![index]);
                      },
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300)),
                            ),
                            child: ListTile(
                              title: Text(allUserProvider.responseAllUser?.data
                                      ?.users?[index].name ??
                                  ""),
                              subtitle: Text(allUserProvider.responseAllUser
                                      ?.data?.users?[index].designation ??
                                  ""),
                              leading: ClipOval(
                                child: CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${allUserProvider.responseAllUser?.data?.users?[index].avatar}",
                                  placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "assets/images/placeholder_image.png"),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Visibility(
                                visible: isMultiSelectionEnabled,
                                child: Icon(
                                  selectedItem.contains(allUserProvider
                                          .responseAllUser!.data!.users![index])
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 26,
                                  color: const Color(0xFF5DB226),
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: isMultiSelectionEnabled,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: CustomButton(
                title: isMultiSelectionEnabled
                    ? getSelectedItemCount()
                    : tr("select_employee"),
                clickButton: () {
                  setState(() {
                    // userId.add(selectedItem.first.id!.toInt());
                    // for (var element in selectedItem) {
                    //   userIds.add(element.id!);
                    //   userNames.add(element.name!);
                    // }
                    Navigator.pop(context, selectedItem);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? "${selectedItem.length} ${tr("item_selected")}"
        : tr("no_item_selected");
  }

  void doMultiSelection(User user) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(user)) {
        selectedItem.remove(user);
      } else {
        selectedItem.add(user);
      }
      setState(() {});
    } else {
      // Other Logic
    }
  }
}
