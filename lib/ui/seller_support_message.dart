import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class SellerSupportMessage extends StatefulWidget {
  final String issue;

  SellerSupportMessage(this.issue);

  @override
  _SellerSupportMessageState createState() => _SellerSupportMessageState();
}

class _SellerSupportMessageState extends State<SellerSupportMessage> {
  PageController pageController = PageController();
  int pageNo = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          hideShadow: true,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: AppTheme.background_grey,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: pageNo == 0
                                      ? AppTheme.secondary_color
                                      : Colors.white,
                                  width: 2))),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Phone',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: pageNo == 1
                                      ? AppTheme.secondary_color
                                      : Colors.white,
                                  width: 2))),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                onPageChanged: (page) {
                  setState(() {
                    print(page);
                    pageNo = page;
                  });
                },
                controller: pageController,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'We will now call you at the phone number listed below',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text('+91',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: SellerSupportTextField(
                                isMultiline: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: AppTheme.secondary_color,
                        child: Text(
                          'call me now',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Your Email',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SellerSupportTextField(
                          isMultiline: false,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Contact Reason',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SellerSupportTextField(
                          isMultiline: false,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Tell us more about issue',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SellerSupportTextField(
                          isMultiline: true,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: AppTheme.secondary_color,
                            child: Text(
                              'send mail',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'seller support will response within 12 hours',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SellerSupportTextField extends StatelessWidget {
  final bool isMultiline;

  SellerSupportTextField({this.isMultiline});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
//                          controller: textEditingController,
//                          textInputAction: textInputAction,

        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.secondary_color,
            fontSize: 16),
        maxLines: isMultiline ? 5 : 1,
        keyboardType: TextInputType.number,
        cursorColor: AppTheme.secondary_color,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        ),
      ),
    );
  }
}
