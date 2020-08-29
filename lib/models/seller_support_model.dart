class SellerSupportModel {
  String title;
  List<String> children;
  SellerSupportModel(this.title, this.children);
}

class SellerSupportModelList {
  List<SellerSupportModel> sellerSupportModelList;
  SellerSupportModelList() {
    sellerSupportModelList = List<SellerSupportModel>();
    sellerSupportModelList.add(SellerSupportModel('Your Account', [
      'Add or change account features',
      'Close Account',
      'Other account issues'
    ]));
    sellerSupportModelList.add(SellerSupportModel('Products', [
      'Wrong product information',
      'Adding or updating products',
      'File uploads',
      'Other listing issues'
    ]));
    sellerSupportModelList.add(SellerSupportModel('Orders', [
      'Customer feedback',
      'Returns, refunds and cancellations',
      'Other order issues'
    ]));
    sellerSupportModelList.add(SellerSupportModel('Payments', [
      'Payment policies and fees',
      'Delayed or missing payments',
      'Other payment issues'
    ]));
    sellerSupportModelList
        .add(SellerSupportModel('Fulfilment by Next Door', ['FBA issues']));
    sellerSupportModelList.add(SellerSupportModel(
        'Next Door partner app', ['Problems using this app']));
    sellerSupportModelList.add(SellerSupportModel('Other issues', [
      'Report a violation',
      'Make a suggestion',
      'Other Next Door services'
    ]));
  }
}
