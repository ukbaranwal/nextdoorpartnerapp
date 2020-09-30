import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/color_variants_bloc.dart';
import 'package:nextdoorpartner/models/color_variant_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ColorVariantsList extends StatefulWidget {
  @override
  _ColorVariantsListState createState() => _ColorVariantsListState();
}

class _ColorVariantsListState extends State<ColorVariantsList> {
  ColorVariantsBloc colorVariantsBloc;
  BoxDecoration boxDecoration = BoxDecoration(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: StreamBuilder(
              stream: colorVariantsBloc.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<ApiResponse<List<ColorVariantModel>>>
                      snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: snapshot.data.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ColorVariantWidget(snapshot.data.data[index]);
                    },
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: SingleChildScrollView(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: 10,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: boxDecoration,
                                  ),
                                  Container(
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    decoration: boxDecoration,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    colorVariantsBloc = ColorVariantsBloc();
    colorVariantsBloc.getColors();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ColorVariantWidget extends StatelessWidget {
  final ColorVariantModel colorVariantModel;

  ColorVariantWidget(this.colorVariantModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            color: colorVariantModel.hexCodeColor,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 70,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              colorVariantModel.name,
              style: TextStyle(
                  color: AppTheme.secondary_color,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
