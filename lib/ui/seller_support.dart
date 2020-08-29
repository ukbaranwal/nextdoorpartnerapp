import 'package:flutter/material.dart';
import 'package:nextdoorpartner/models/seller_support_model.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/seller_support_message.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class SellerSupport extends StatefulWidget {
  @override
  _SellerSupportState createState() => _SellerSupportState();
}

class _SellerSupportState extends State<SellerSupport> {
  SellerSupportModelList sellerSupportModelList = SellerSupportModelList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  'please select your reason for contacting us',
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      thickness: 1,
                      height: 2,
                      color: AppTheme.background_grey,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    itemCount:
                        sellerSupportModelList.sellerSupportModelList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return SellerSupportWidget(
                          sellerSupportModelList
                              .sellerSupportModelList[index].title,
                          sellerSupportModelList
                              .sellerSupportModelList[index].children);
                    },
                  )),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SellerSupportChildWidget extends StatelessWidget {
  final String label;

  SellerSupportChildWidget(this.label);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SellerSupportMessage(label),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}

class SellerSupportWidget extends StatefulWidget {
  final String label;
  final List<String> children;

  SellerSupportWidget(this.label, this.children);
  @override
  _SellerSupportWidgetState createState() => _SellerSupportWidgetState();
}

class _SellerSupportWidgetState extends State<SellerSupportWidget> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label,
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                isVisible
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
        ),
        isVisible
            ? ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1,
                  height: 2,
                  color: AppTheme.background_grey,
                ),
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 15),
                itemCount: widget.children.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return SellerSupportChildWidget(widget.children[index]);
                },
              )
            : SizedBox()
      ],
    );
  }
}
