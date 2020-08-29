import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:fswitch/fswitch.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextdoorpartner/bloc/product_bloc.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:path_provider/path_provider.dart';

class Product extends StatefulWidget {
  final bool isNewProduct;
  final int productCategoryId;
  final ProductModel productModel;

  Product({this.isNewProduct, this.productModel, this.productCategoryId});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  ProductCategoryModel productCategoryModel;
  ProductModel productModel;
  ProductBloc productBloc;
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

  ProgressDialog progressDialog;

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

  void checkForValidation() {
    if (nameTextEditingController.text.length == 0) {
      CustomToast.show('name field can\'t be empty', context);
      return;
    } else if (mrpTextEditingController.text.length == 0) {
      CustomToast.show('enter mrp', context);
      return;
    } else if (mrpTextEditingController.text.length == 0) {
      CustomToast.show('enter mrp', context);
      return;
    } else if (standardTextEditingController.text.length == 0) {
      CustomToast.show('Choose the standard quality of selling', context);
      return;
    } else if (files.length == 0) {
      CustomToast.show('Please upload a photo', context);
      return;
    }
    uploadToServer(productCategoryModel.productCategoryId);
  }

  void deleteImage(int index) {
    widget.productModel.images.removeAt(index - 1);
  }

  void replaceImage() {}

  void showDeleteDialog(int index) {
    Dialog dialog;
    dialog = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
              Strings.hostUrl + widget.productModel.images[index - 1].imageUrl),
          InkWell(
            onTap: () {
              if (widget.productModel.images.length == 1) {
                replaceImage();
                return;
              }
              deleteImage(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                'Delete Image',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
    showDialog(context: context, child: dialog);
  }

  void uploadToServer(int productCategoryId) {
    ProductModel productModel = ProductModel(
        null,
        -1,
        nameTextEditingController.text,
        productCategoryId,
        brandTextEditingController.text,
        descriptionTextEditingController.text,
        double.parse(standardTextEditingController.text),
        double.parse(mrpTextEditingController.text),
        int.parse(discountTextEditingController.text) ?? 0,
        true,
        'hgjgjgj',
        0,
        0,
        0,
        false,
        true,
        false, [], [], []);
    productBloc.addProduct(productModel, files);
    productBloc.productApiStream.listen((event) {
      if (event.status == Status.SUCCESSFUL) {
        print(event.toString());

        ///Server will give the product id
        productModel.productId = event.data['product_id'];

        ///Need to parse the data type after retrieval
        productModel.parseImages(event.data['images']);

        insertInDb(productModel);
//        Navigator.pop(context);
//        Navigator.pop(context);
      }
    });
  }

  void loadTags() {
    tagsList = productCategoryModel.tags.split(',');
    for (String i in tagsList) {
      tagsWidgetList.add(TagsWidget(boxDecoration: boxDecoration, tags: i));
    }
  }

  void insertInDb(ProductModel productModel) {
    productBloc.insertProduct(productModel);
    productBloc.productStream.listen((event) {
      print(event.toString());
      if (event.status == DBStatus.SUCCESSFUL) {
        CustomToast.show('Successfully Added', context);
      }
    });
  }

  void populateFields() {
    setState(() {
      nameTextEditingController.text = widget.productModel.name;
      brandTextEditingController.text = widget.productModel.brand;
      descriptionTextEditingController.text = widget.productModel.description;
      mrpTextEditingController.text = widget.productModel.mrp.toString();
      discountTextEditingController.text =
          widget.productModel.discountPercentage.toString();
      standardTextEditingController.text =
          widget.productModel.standardQuantityOfSelling.toString();
    });
  }

  List<String> tagsList;
  List<TagsWidget> tagsWidgetList = List<TagsWidget>();

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc();
    if (widget.isNewProduct) {
//      loadTags();
    } else {
      populateFields();
    }
    productBloc.getProductCategory(widget.productCategoryId);
//    VendorDatabaseProvider vendorDatabaseProvider = VendorDatabaseProvider();
//    vendorDatabaseProvider.initiate();
  }

  @override
  void dispose() {
    productBloc.dispose();
    super.dispose();
  }

  Future<Null> _pickImage(int index) async {
    imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        if (widget.isNewProduct) {
          _cropImage(File(imageFile.path), index);
        } else {
          _cropImageUpdate(File(imageFile.path));
        }
      });
    }
  }

  Future<Null> _cropImageUpdate(File file) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (croppedFile != null) {
      setState(() {});
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
        bottomNavigationBar: InkWell(
          onTap: () {
            checkForValidation();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(color: AppTheme.green, boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, -1),
                  color: Colors.black.withOpacity(0.4))
            ]),
            child: Text(
              widget.isNewProduct ? Strings.addProduct : 'Update Product',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        backgroundColor: AppTheme.background_grey,
        body: StreamBuilder(
            stream: productBloc.productCategoryStream,
            builder: (context,
                AsyncSnapshot<DbResponse<ProductCategoryModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                productCategoryModel = snapshot.data.data;
                print(snapshot.data.data);
                return SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  InkWell(
                                    onTap: () {
//                                          print(files[0].path);
                                    },
                                    child: Container(
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
                                                color:
                                                    AppTheme.secondary_color),
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
                                                color:
                                                    AppTheme.secondary_color),
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        spacing: snapshot.data.data.noOfPhotos == 1 ? 0 : 10,
                        children: [
                          snapshot.data.data.noOfPhotos > 0
                              ? (!widget.isNewProduct &&
                                      widget.productModel.images.length > 0)
                                  ? ImageShowerWidget(
                                      showDialog: showDeleteDialog,
                                      imageUrl: widget
                                          .productModel.images[0].imageUrl,
                                      index: 1)
                                  : ImagePickerWidget(
                                      boxDecoration: boxDecoration,
                                      file: files.length > 0 ? files[0] : null,
                                      pickImage: _pickImage,
                                      index: 1,
                                    )
                              : SizedBox(),
                          snapshot.data.data.noOfPhotos > 1
                              ? (!widget.isNewProduct &&
                                      widget.productModel.images.length > 1)
                                  ? ImageShowerWidget(
                                      showDialog: showDeleteDialog,
                                      imageUrl: widget
                                          .productModel.images[1].imageUrl,
                                      index: 2)
                                  : ImagePickerWidget(
                                      boxDecoration: boxDecoration,
                                      file: files.length > 1 ? files[1] : null,
                                      pickImage: _pickImage,
                                      index: 2,
                                    )
                              : SizedBox(),
                          snapshot.data.data.noOfPhotos > 2
                              ? (!widget.isNewProduct &&
                                      widget.productModel.images.length > 2)
                                  ? ImageShowerWidget(
                                      showDialog: showDeleteDialog,
                                      imageUrl: widget
                                          .productModel.images[2].imageUrl,
                                      index: 3)
                                  : ImagePickerWidget(
                                      boxDecoration: boxDecoration,
                                      file: files.length > 2 ? files[2] : null,
                                      pickImage: _pickImage,
                                      index: 3,
                                    )
                              : SizedBox(),
                          snapshot.data.data.noOfPhotos > 3
                              ? (!widget.isNewProduct &&
                                      widget.productModel.images.length > 3)
                                  ? ImageShowerWidget(
                                      showDialog: showDeleteDialog,
                                      imageUrl: widget
                                          .productModel.images[3].imageUrl,
                                      index: 4)
                                  : ImagePickerWidget(
                                      boxDecoration: boxDecoration,
                                      file: files.length > 3 ? files[3] : null,
                                      pickImage: _pickImage,
                                      index: 4,
                                    )
                              : SizedBox(),
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
                        isMultiline: false,
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
                        isMultiline: false,
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
                        isMultiline: true,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: mrpTextEditingController,
                        labelText: Strings.mrp +
                            (snapshot.data.data.quantityByPiece
                                ? '(Per Piece)'
                                : '(Per Kg)'),
                        changeFocus: changeFocus,
                        focusScopeNode: mrpFocusNode,
                        textInputType: TextInputType.number,
                        isMarginApplicable: false,
                        isMultiline: false,
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
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: standardTextEditingController,
                        labelText: Strings.standardQuantityOfSelling,
                        changeFocus: changeFocus,
                        focusScopeNode: standardFocusNode,
                        textInputType: TextInputType.number,
                        isMarginApplicable: false,
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: tagsTextEditingController,
                        labelText: Strings.tags,
                        changeFocus: changeFocus,
                        focusScopeNode: tagsFocusNode,
                        textInputType: TextInputType.text,
                        isMarginApplicable: true,
                        isMultiline: false,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        width: MediaQuery.of(context).size.width - 10,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 5,
                          spacing: 5,
                          children: tagsWidgetList,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      snapshot.data.data.haveColorVariants &&
                              !widget.isNewProduct
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 20,
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
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
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
                            )
                          : SizedBox(),
                      snapshot.data.data.haveSizeVariants &&
                              !widget.isNewProduct
                          ? Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  margin: EdgeInsets.only(top: 10),
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
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [SizeWidget(size: 'XXL')],
                                  ),
                                )
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class ProductTextInputWidget extends StatelessWidget {
  ProductTextInputWidget({
    this.boxDecoration,
    this.isMultiline,
    this.textInputType,
    this.labelText,
    this.textInputAction,
    this.focusScopeNode,
    this.changeFocus,
    this.textEditingController,
    this.isMarginApplicable,
  });
  final BoxDecoration boxDecoration;
  final TextInputType textInputType;
  final String labelText;
  final TextInputAction textInputAction;
  final FocusScopeNode focusScopeNode;
  final Function changeFocus;
  final TextEditingController textEditingController;
  final bool isMarginApplicable;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: isMarginApplicable ? 10 : 0),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: textInputAction,
        maxLines: isMultiline ? 5 : 1,
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

class ImageShowerWidget extends StatelessWidget {
  ImageShowerWidget({this.imageUrl, this.index, this.showDialog});
  final String imageUrl;
  final int index;
  final Function showDialog;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Image.network(
          Strings.hostUrl + imageUrl,
          height: MediaQuery.of(context).size.width * 0.21,
          width: MediaQuery.of(context).size.width * 0.21,
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
