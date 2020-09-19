import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/change_password_bloc.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  FocusScopeNode currentPasswordFocusNode = FocusScopeNode();
  FocusScopeNode newPasswordFocusNode = FocusScopeNode();
  FocusScopeNode confirmPasswordFocusNode = FocusScopeNode();
  TextEditingController currentPasswordTextEditingController =
      TextEditingController();
  TextEditingController newPasswordTextEditingController =
      TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  ScrollController scrollController = ScrollController();

  ChangePasswordBloc changePasswordBloc;

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == currentPasswordFocusNode) {
      focusScopeNode2 = newPasswordFocusNode;
      scrollController.animateTo(50,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else if (focusScopeNode == newPasswordFocusNode) {
      focusScopeNode2 = confirmPasswordFocusNode;
      scrollController.animateTo(100,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else {
      confirmPasswordFocusNode.unfocus();
      checkForValidation();
      return;
    }
    FocusScope.of(context).requestFocus(focusScopeNode2);
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
    if (currentPasswordTextEditingController.text.length < 8) {
      CustomToast.show('Old Password was of at least 8 characters', context);
      return;
    } else if (newPasswordTextEditingController.text.length < 8) {
      CustomToast.show(
          'New password should be of at least 8 characters', context);
      return;
    } else if (confirmPasswordTextEditingController.text !=
        newPasswordTextEditingController.text) {
      CustomToast.show('Both password don\'t match', context);
      return;
    }
    changePasswordBloc.changePassword(currentPasswordTextEditingController.text,
        newPasswordTextEditingController.text);
    changePasswordBloc.changePasswordStream.listen((event) {
      if (event.loader == LOADER.HIDE) {
        CustomToast.show(event.message, context);
        Navigator.pop(context);
      } else if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      }
      if (event.actions == ApiActions.SUCCESSFUL) {
        signOut();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    changePasswordBloc = ChangePasswordBloc();
  }

  void signOut() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    sharedPreferences.clear();
    await Future.delayed(Duration(milliseconds: 1000));
    CustomToast.show('You have successfully logged out', context);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return Login();
      },
    ), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Change Password',
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontWeight: FontWeight.w700,
                      fontSize: 26),
                ),
                SizedBox(
                  height: 20,
                ),
                ChangePasswordInputWidget(
                  hintText: 'Current Password',
                  textEditingController: currentPasswordTextEditingController,
                  textInputAction: TextInputAction.next,
                  focusNode: currentPasswordFocusNode,
                  onFieldSubmitted: changeFocus,
                ),
                ChangePasswordInputWidget(
                  hintText: 'New Password',
                  textEditingController: newPasswordTextEditingController,
                  textInputAction: TextInputAction.next,
                  focusNode: newPasswordFocusNode,
                  onFieldSubmitted: changeFocus,
                ),
                ChangePasswordInputWidget(
                  hintText: 'Confirm Password',
                  textEditingController: confirmPasswordTextEditingController,
                  textInputAction: TextInputAction.done,
                  focusNode: confirmPasswordFocusNode,
                  onFieldSubmitted: changeFocus,
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      checkForValidation();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                          color: AppTheme.secondary_color,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    changePasswordBloc.dispose();
    super.dispose();
  }
}

class ChangePasswordInputWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  ChangePasswordInputWidget(
      {this.hintText,
      this.textEditingController,
      this.textInputAction,
      this.focusNode,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          hintText,
          style: TextStyle(
              color: AppTheme.secondary_color,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              color: AppTheme.background_grey,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: TextFormField(
            focusNode: focusNode,
            obscureText: true,
            controller: textEditingController,
            cursorColor: AppTheme.secondary_color,
            textInputAction: textInputAction,
            onFieldSubmitted: (value) => onFieldSubmitted(focusNode),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.secondary_color,
                fontSize: 18),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 10, bottom: 11, top: 11, right: 10),
            ),
            onEditingComplete: () {},
          ),
        ),
      ],
    );
  }
}
