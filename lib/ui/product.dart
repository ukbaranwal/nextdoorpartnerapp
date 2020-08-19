import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fswitch/fswitch.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextdoorpartner/models/product_category.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class Product extends StatefulWidget {
  final bool isNewProduct;
  final ProductCategoryModel productCategoryModel;

  Product({this.isNewProduct, this.productCategoryModel});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  PickedFile imageFile;
  List<File> files = List<File>();
  ImagePicker imagePicker = ImagePicker();
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController brandTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController mrpTextEditingController =
      TextEditingController();
  final TextEditingController discountTextEditingController =
      TextEditingController();
  final TextEditingController tagsTextEditingController =
      TextEditingController();
  final TextEditingController standardTextEditingController =
      TextEditingController();
  FocusScopeNode nameFocusNode = FocusScopeNode();
  FocusScopeNode brandFocusNode = FocusScopeNode();
  FocusScopeNode descriptionFocusNode = FocusScopeNode();
  FocusScopeNode mrpFocusNode = FocusScopeNode();
  FocusScopeNode discountFocusNode = FocusScopeNode();
  FocusScopeNode tagsFocusNode = FocusScopeNode();
  FocusScopeNode standardFocusNode = FocusScopeNode();

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == nameFocusNode) {
      focusScopeNode2 = brandFocusNode;
    } else if (focusScopeNode == brandFocusNode) {
      focusScopeNode2 = descriptionFocusNode;
    } else if (focusScopeNode == descriptionFocusNode) {
      focusScopeNode2 = mrpFocusNode;
    } else if (focusScopeNode == mrpFocusNode) {
      focusScopeNode2 = discountFocusNode;
    } else if (focusScopeNode == discountFocusNode) {
      focusScopeNode2 = tagsFocusNode;
    } else if (focusScopeNode == tagsFocusNode) {
      focusScopeNode2 = standardFocusNode;
    }
    FocusScope.of(context).requestFocus(focusScopeNode2);
  }

  @override
  void initState() {
    super.initState();
    print(widget.productCategoryModel.name);
  }

  Future<Null> _pickImage(int index) async {
    imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _cropImage(File(imageFile.path), index);
      });
    }
  }

  Future<Null> _cropImage(File file, int index) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (croppedFile != null) {
      setState(() {
        if (index <= files.length) {
          print(1);
          files.removeAt(index - 1);
          files.insert(index - 1, croppedFile);
        } else {
          files.add(croppedFile);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  widget.isNewProduct
                      ? Container(
                          decoration: boxDecoration,
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            Strings.chooseFromOurListOfProducts,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.secondary_color),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FSwitch(
                                width: 40,
                                height: 20,
                                openColor: AppTheme.green,
                                open: true,
                                onChanged: (value) {
                                  setState(() {
//                              isSwitchedOn = value;
                                  });
                                },
                              ),
                              Container(
                                decoration: boxDecoration,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  'product id : 1234',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.secondary_color),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '400',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.secondary_color),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Icon(
                                        Icons.remove_red_eye,
                                        size: 12,
                                        color: AppTheme.secondary_color,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '400',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.secondary_color),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Icon(
                                        Icons.shopping_basket,
                                        size: 12,
                                        color: AppTheme.secondary_color,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ImagePickerWidget(
                        boxDecoration: boxDecoration,
                        file: files.length > 0 ? files[0] : null,
                        pickImage: _pickImage,
                        index: 1,
                      ),
                      ImagePickerWidget(
                        boxDecoration: boxDecoration,
                        file: files.length > 1 ? files[1] : null,
                        pickImage: _pickImage,
                        index: 2,
                      ),
                      ImagePickerWidget(
                        boxDecoration: boxDecoration,
                        file: files.length > 2 ? files[2] : null,
                        pickImage: _pickImage,
                        index: 3,
                      ),
                      ImagePickerWidget(
                        boxDecoration: boxDecoration,
                        file: files.length > 3 ? files[3] : null,
                        pickImage: _pickImage,
                        index: 4,
                      ),
                    ],
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: nameTextEditingController,
                    labelText: Strings.name,
                    changeFocus: changeFocus,
                    focusScopeNode: nameFocusNode,
                    textInputType: TextInputType.name,
                    isMarginApplicable: true,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: brandTextEditingController,
                    labelText: Strings.brand,
                    changeFocus: changeFocus,
                    focusScopeNode: brandFocusNode,
                    textInputType: TextInputType.name,
                    isMarginApplicable: false,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: descriptionTextEditingController,
                    labelText: Strings.description,
                    changeFocus: changeFocus,
                    focusScopeNode: descriptionFocusNode,
                    textInputType: TextInputType.name,
                    isMarginApplicable: true,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: mrpTextEditingController,
                    labelText: Strings.mrp,
                    changeFocus: changeFocus,
                    focusScopeNode: mrpFocusNode,
                    textInputType: TextInputType.number,
                    isMarginApplicable: false,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: discountTextEditingController,
                    labelText: Strings.discount,
                    changeFocus: changeFocus,
                    focusScopeNode: discountFocusNode,
                    textInputType: TextInputType.number,
                    isMarginApplicable: true,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: tagsTextEditingController,
                    labelText: Strings.tags,
                    changeFocus: changeFocus,
                    focusScopeNode: tagsFocusNode,
                    textInputType: TextInputType.text,
                    isMarginApplicable: false,
                  ),
                  ProductTextInputWidget(
                    boxDecoration: boxDecoration,
                    textInputAction: TextInputAction.next,
                    textEditingController: standardTextEditingController,
                    labelText: Strings.standardQuantityOfSelling,
                    changeFocus: changeFocus,
                    focusScopeNode: standardFocusNode,
                    textInputType: TextInputType.number,
                    isMarginApplicable: true,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width - 10,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 5,
                      spacing: 5,
                      children: [
                        TagsWidget(
                            boxDecoration: boxDecoration, tags: 'noodles'),
                        TagsWidget(boxDecoration: boxDecoration, tags: 'maggi'),
                        TagsWidget(
                            boxDecoration: boxDecoration, tags: 'top ramen'),
                        TagsWidget(
                            boxDecoration: boxDecoration, tags: 'yippee'),
                        TagsWidget(
                            boxDecoration: boxDecoration, tags: 'chings'),
                        TagsWidget(
                            boxDecoration: boxDecoration, tags: 'chowmein'),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: boxDecoration,
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color,
                          fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        labelText: Strings.standardQuantityOfSelling,
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          color: Color(0xffB9BABC),
                        ),
                      ),
                      onEditingComplete: () {},
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5 - 15,
                            decoration: boxDecoration,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Strings.addColorVariant,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.secondary_color)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add_box,
                                  size: 16,
                                  color: AppTheme.secondary_color,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5 - 15,
                            child: Wrap(
                              runSpacing: 5,
                              spacing: 5,
                              children: [
                                ColorWidget(
                                  color: Colors.teal,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5 - 15,
                            decoration: boxDecoration,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Strings.addSizeVariant,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.secondary_color)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add_box,
                                  size: 16,
                                  color: AppTheme.secondary_color,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5 - 15,
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [SizeWidget(size: 'XXL')],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: AppTheme.green, boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, -1),
                    color: Colors.black.withOpacity(0.4))
              ]),
              child: Text(
                Strings.addProduct,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductTextInputWidget extends StatelessWidget {
  ProductTextInputWidget(
      {this.boxDecoration,
      this.textInputType,
      this.labelText,
      this.textInputAction,
      this.focusScopeNode,
      this.changeFocus,
      this.textEditingController,
      this.isMarginApplicable});
  final BoxDecoration boxDecoration;
  final TextInputType textInputType;
  final String labelText;
  final TextInputAction textInputAction;
  final FocusScopeNode focusScopeNode;
  final Function changeFocus;
  final TextEditingController textEditingController;
  final bool isMarginApplicable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: isMarginApplicable ? 10 : 0),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: textInputAction,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.secondary_color,
            fontSize: 16),
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: Color(0xffB9BABC),
          ),
        ),
      ),
    );
  }
}

class ImagePickerWidget extends StatelessWidget {
  ImagePickerWidget(
      {this.boxDecoration, this.file, this.pickImage, this.index});

  final BoxDecoration boxDecoration;
  final File file;
  final Function pickImage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickImage(index);
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 0.21,
        width: MediaQuery.of(context).size.width * 0.21,
        decoration: boxDecoration,
        child: file != null
            ? ClipRRect(
                child: Image.file(file),
                borderRadius: BorderRadius.circular(5),
              )
            : Icon(
                Icons.add_a_photo,
                size: 40,
                color: AppTheme.background_grey,
              ),
      ),
    );
  }
}

class TagsWidget extends StatelessWidget {
  final BoxDecoration boxDecoration;
  final String tags;

  TagsWidget({@required this.boxDecoration, @required this.tags});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: boxDecoration,
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Text(
                tags,
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                'assets/images/cross.png',
                height: 14,
                width: 14,
              )
            ],
          ),
        )
      ],
    );
  }
}

class ColorWidget extends StatelessWidget {
  final Color color;

  ColorWidget({@required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class SizeWidget extends StatelessWidget {
  final String size;

  SizeWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Text(
        size,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.secondary_color),
      ),
    );
  }
}
