import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nextdoorpartner/bloc/help_page_bloc.dart';
import 'package:nextdoorpartner/bloc/help_page_content_bloc.dart';
import 'package:nextdoorpartner/models/help_model.dart';
import 'package:nextdoorpartner/models/seller_support_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/seller_support_message.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class HelpContentPage extends StatefulWidget {
  final int index;

  HelpContentPage(this.index);

  @override
  _HelpContentPageState createState() => _HelpContentPageState();
}

class _HelpContentPageState extends State<HelpContentPage> {
  HelpPageContentBloc helpPageContentBloc;

  @override
  void initState() {
    super.initState();
    helpPageContentBloc = HelpPageContentBloc();
    helpPageContentBloc.getContent(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          child: StreamBuilder<ApiResponse<String>>(
              stream: helpPageContentBloc.helpPageStream,
              builder: (context, AsyncSnapshot<ApiResponse<String>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Html(
                      data: snapshot.data.data,
                    ),
                  );
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
    helpPageContentBloc.dispose();
    super.dispose();
  }
}
