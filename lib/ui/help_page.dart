import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/help_page_bloc.dart';
import 'package:nextdoorpartner/models/help_model.dart';
import 'package:nextdoorpartner/models/seller_support_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/help_page_content.dart';
import 'package:nextdoorpartner/ui/seller_support_message.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  HelpPageBloc helpPageBloc;

  @override
  void initState() {
    super.initState();
    helpPageBloc = HelpPageBloc();
    helpPageBloc.getHelpTabs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          child: StreamBuilder<ApiResponse<HelpModel>>(
              stream: helpPageBloc.helpPageStream,
              builder:
                  (context, AsyncSnapshot<ApiResponse<HelpModel>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        itemCount: snapshot.data.data.tabs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HelpContentPage(index)));
                            },
                            child: HelpWidget(
                              snapshot.data.data.tabs[index],
                            ),
                          );
                        },
                      ));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    helpPageBloc.dispose();
    super.dispose();
  }
}

class HelpWidget extends StatelessWidget {
  final String label;

  HelpWidget(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
