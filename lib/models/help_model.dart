class HelpModel {
  List<String> tabs;
  HelpModel.fromJson(List<dynamic> parsedJson) {
    tabs = List<String>();
    for (var i in parsedJson) {
      tabs.add(i);
    }
  }
}
