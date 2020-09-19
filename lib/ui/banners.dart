import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextdoorpartner/bloc/banner_bloc.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shimmer/shimmer.dart';

import 'app_bar.dart';

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  BannerBloc bannerBloc;
  PickedFile imageFile;
  ImagePicker imagePicker = ImagePicker();
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0X00FFFFFF),
      builder: (context) {
        return LoadingDialog();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bannerBloc = BannerBloc();
    bannerBloc.init();

    bannerBloc.bannerStream.listen((event) {
      if (event.loader == LOADER.HIDE) {
        CustomToast.show(event.message, context);
        Navigator.pop(context);
      } else if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      }
    });
  }

  void showDeleteDialog(int index, String imageUrl) {
    Dialog dialog;
    dialog = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: Strings.hostUrl + imageUrl,
          ),
          InkWell(
            onTap: () {
              bannerBloc.deleteBanner(index);
              Navigator.pop(context);
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
        CropAspectRatioPreset.ratio16x9,
      ],
    );
    if (croppedFile != null) {
      bannerBloc.addBanner(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          child: StreamBuilder<ApiResponse<List<String>>>(
              stream: bannerBloc.bannerStream,
              builder:
                  (context, AsyncSnapshot<ApiResponse<List<String>>> snapshot) {
                print(snapshot);
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Text(
                          'Live Banners(${snapshot.data.data.length})',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        itemCount: snapshot.data.data.length + 1,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 5) {
                            return SizedBox();
                          } else if (index == snapshot.data.data.length) {
                            return InkWell(
                                onTap: () {
                                  _pickImage(index - 1);
                                },
                                child: BannerAddWidget());
                          } else {
                            return InkWell(
                              child: BannerWidget(
                                snapshot.data.data[index],
                              ),
                              onTap: () {
                                showDeleteDialog(
                                    index, snapshot.data.data[index]);
                              },
                            );
                          }

                          ///Return Single Widget
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: 3,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height:
                                    (MediaQuery.of(context).size.width - 20) /
                                        (16 / 9),
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: boxDecoration,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bannerBloc.dispose();
    super.dispose();
  }
}

class BannerAddWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: MediaQuery.of(context).size.width / (16 / 9),
      color: Colors.white,
      child: Icon(
        Icons.add_to_photos,
        size: 64,
        color: AppTheme.background_grey,
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String url;

  BannerWidget(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CachedNetworkImage(
        imageUrl: Strings.hostUrl + url,
        height: (MediaQuery.of(context).size.width - 20) / (16 / 9),
      ),
    );
  }
}
