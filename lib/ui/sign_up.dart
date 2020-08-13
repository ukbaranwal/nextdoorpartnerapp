import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 22,
                    color: AppTheme.secondary_color,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                      color: AppTheme.primary_color,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(60))),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Text(
                  Strings.createAccount,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: AppTheme.primary_color,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      SignUpInputCard(
                        icon: Icons.account_circle,
                        hintText: 'Name',
                      ),
                      SignUpInputCard(
                        icon: Icons.location_city,
                        hintText: 'City',
                      ),
                      SignUpInputCard(
                        icon: Icons.phone_iphone,
                        hintText: 'Mobile',
                      ),
                      SignUpInputCard(
                        icon: Icons.email,
                        hintText: 'Email',
                      ),
                      SignUpInputCard(
                        icon: Icons.lock,
                        hintText: 'Password',
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(
                                left: 20, right: 30, top: 8, bottom: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40)),
                              color: AppTheme.secondary_color,
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
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignUpInputCard extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController textEditingController;

  SignUpInputCard({this.icon, this.hintText, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: <Widget>[
            Padding(
              child: Icon(
                icon,
                size: 25,
                color: AppTheme.secondary_color,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                controller: textEditingController,
                cursorColor: AppTheme.secondary_color,
                onFieldSubmitted: (value) => {},
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary_color,
                    fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 10, bottom: 11, top: 11, right: 10),
                    hintText: hintText),
                onEditingComplete: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
