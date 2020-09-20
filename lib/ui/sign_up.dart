import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:nextdoorpartner/bloc/signup_bloc.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/ui/terms_and_conditions.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import '../util/custom_toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpBloc signUpBloc;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  ProgressDialog progressDialog;
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController cityTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  FocusScopeNode nameFocusNode = FocusScopeNode();
  FocusScopeNode cityFocusNode = FocusScopeNode();
  FocusScopeNode phoneFocusNode = FocusScopeNode();
  FocusScopeNode emailFocusNode = FocusScopeNode();
  FocusScopeNode passwordFocusNode = FocusScopeNode();

  ScrollController scrollController = ScrollController();

  ///To Validate Email
  bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  void signUp() async {
    bool hasAcceptedTerms = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TermsAndConditions()));
    if (!hasAcceptedTerms) {
      CustomToast.show(
          'You need to Accept our Terms and Conditions to move forward',
          context);
      return;
    }
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    print(androidDeviceInfo.id);
    signUpBloc.doSignUp(
        nameTextEditingController.text,
        emailTextEditingController.text,
        phoneTextEditingController.text,
        cityTextEditingController.text,
        passwordTextEditingController.text,
        androidDeviceInfo.id);
  }

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

  void checkForValidation() {
    if (nameTextEditingController.text.length == 0) {
      CustomToast.show('name field can\'t be empty', context);
      return;
    } else if (cityTextEditingController.text.length == 0) {
      CustomToast.show('city field can\'t be empty', context);
      return;
    } else if (phoneTextEditingController.text.length != 10) {
      CustomToast.show('enter a valid mobile number', context);
      return;
    } else if (!isValidEmail(emailTextEditingController.text)) {
      CustomToast.show('enter a valid email', context);
      return;
    } else if (passwordTextEditingController.text.length < 8) {
      CustomToast.show('password should of atleast 8 characters', context);
      return;
    }
    signUp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    signUpBloc = SignUpBloc();
    signUpBloc.signUpStream.listen((event) {
      if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      } else if (event.loader == LOADER.HIDE) {
        CustomToast.show(event.message, context);
        Navigator.pop(context);
      }
      if (event.actions == ApiActions.SUCCESSFUL) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }
    });
  }

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == nameFocusNode) {
      focusScopeNode2 = cityFocusNode;
      scrollController.animateTo(50,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else if (focusScopeNode == cityFocusNode) {
      focusScopeNode2 = phoneFocusNode;
      scrollController.animateTo(100,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else if (focusScopeNode == phoneFocusNode) {
      focusScopeNode2 = emailFocusNode;
      scrollController.animateTo(150,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else if (focusScopeNode == emailFocusNode) {
      focusScopeNode2 = passwordFocusNode;
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else {
      passwordFocusNode.unfocus();
      checkForValidation();
      return;
    }
    FocusScope.of(context).requestFocus(focusScopeNode2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 22,
                                color: AppTheme.secondary_color,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                color: AppTheme.primary_color,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60))),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 20),
                          child: Text(
                            Strings.createAccount,
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
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
                              focusNode: nameFocusNode,
                              onFieldSubmitted: changeFocus,
                              textEditingController: nameTextEditingController,
                              icon: Icons.account_circle,
                              hintText: Strings.Name,
                              textInputType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            SignUpInputCard(
                              focusNode: cityFocusNode,
                              onFieldSubmitted: changeFocus,
                              textEditingController: cityTextEditingController,
                              icon: Icons.location_city,
                              hintText: Strings.City,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            SignUpInputCard(
                              focusNode: phoneFocusNode,
                              onFieldSubmitted: changeFocus,
                              textEditingController: phoneTextEditingController,
                              icon: Icons.phone_iphone,
                              hintText: Strings.Mobile,
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            SignUpInputCard(
                              focusNode: emailFocusNode,
                              onFieldSubmitted: changeFocus,
                              textEditingController: emailTextEditingController,
                              icon: Icons.email,
                              hintText: Strings.email,
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SignUpInputCard(
                              focusNode: passwordFocusNode,
                              onFieldSubmitted: changeFocus,
                              textEditingController:
                                  passwordTextEditingController,
                              icon: Icons.lock,
                              hintText: Strings.Password,
                              textInputType: TextInputType.text,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                            ),
                            Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      Strings.login,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 60,
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
                                    onPressed: () {
                                      checkForValidation();
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    signUpBloc.dispose();
    super.dispose();
  }
}

class SignUpInputCard extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController textEditingController;
  final bool isPassword;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  SignUpInputCard(
      {this.icon,
      this.hintText,
      this.textEditingController,
      this.isPassword,
      this.textInputType,
      this.textInputAction,
      this.focusNode,
      this.onFieldSubmitted});

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
                focusNode: focusNode,
                obscureText: isPassword ?? false,
                controller: textEditingController,
                cursorColor: AppTheme.secondary_color,
                textInputAction: textInputAction,
                onFieldSubmitted: (value) => onFieldSubmitted(focusNode),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary_color,
                    fontSize: 18),
                keyboardType: textInputType,
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color,
                        fontSize: 18),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 10, bottom: 11, top: 11, right: 10),
                    labelText: hintText),
                onEditingComplete: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
