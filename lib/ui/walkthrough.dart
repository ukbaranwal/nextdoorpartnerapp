import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/models/walkthrough_model.dart';
import 'package:nextdoorpartner/ui/get_started.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalkThrough extends StatefulWidget {
  final List<WalkThroughModel> walkThroughModelList;

  WalkThrough({@required this.walkThroughModelList});

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final controller = PageController();
  Color buttonColor = AppTheme.primary_color;
  List<WalkThroughPage> walkThroughPageList;
  int currentPage = 0;

  void changeButtonColor(int index) {
    setState(() {
      buttonColor = widget.walkThroughModelList[index].color;
    });
  }

  @override
  void initState() {
    super.initState();
    walkThroughPageList = List<WalkThroughPage>();
    for (var i in widget.walkThroughModelList) {
      walkThroughPageList.add(
          WalkThroughPage(i.heading, i.subHeading, i.assetImagePath, i.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                currentPage != 0
                    ? Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                        color: AppTheme.secondary_color,
                      )
                    : SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetStarted(),
                      ),
                    );
                  },
                  child: Text(
                    'skip',
                    style: TextStyle(
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: PageView(
                  controller: controller,
                  children: walkThroughPageList,
                  onPageChanged: (index) {
                    currentPage = index;
                    changeButtonColor(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: SmoothPageIndicator(
                  count: 3,
                  controller: controller,
                  effect: ExpandingDotsEffect(
                      spacing: 8,
                      radius: 6,
                      activeDotColor: Color(0xffB2A2FF),
                      dotColor: Color(0xffD8D8D8),
                      dotHeight: 12,
                      dotWidth: 18,
                      paintStyle: PaintingStyle.fill,
                      expansionFactor: 1.5),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.only(left: 20, right: 30, top: 8, bottom: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
              color: buttonColor,
            ),
            alignment: Alignment.bottomRight,
            child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {},
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WalkThroughPage extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String assetImagePath;
  final Color cardColor;

  WalkThroughPage(
      this.heading, this.subHeading, this.assetImagePath, this.cardColor);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/rectangle.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 586 / 510,
          ),
          Container(
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.all(Radius.circular(40))),
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.2),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Image.asset('assets/images/$assetImagePath'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 22),
                ),
                Text(
                  subHeading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
