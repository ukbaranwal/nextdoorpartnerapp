import 'package:flutter/material.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class ProductCategory extends StatefulWidget {
  @override
  _ProductCategoryState createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  List<ProductCategoryModel> productCategoryModelList =
      List<ProductCategoryModel>();

  ///SqLite
  VendorDatabaseProvider vendorDatabaseProvider = VendorDatabaseProvider();

  ///To hold parent id for every level
  List<int> listParentId = List<int>();

  ///To Count the level
  int count = 0;

  ///Used for recursive widget
  Widget categoryWidgetList = SizedBox();

  ///Selected Category
  ProductCategoryModel selectedCategory;

  Future<Widget> getCategoryList() async {
    if (count == listParentId.length) {
      return SizedBox();
    }
    List<ProductCategoryModel> temp = await vendorDatabaseProvider
        .getProductCategoriesParentId(listParentId[count]);
    count++;
    return CategoryLabelList(
      productCategoryModelList: temp,
      parentId: count < listParentId.length ? listParentId[count] : -1,
      level: count,
      reload: reload,
      select: select,
      widget: await getCategoryList(),
    );
  }

  void select(ProductCategoryModel productCategoryModel) async {
    setState(() {
      selectedCategory = productCategoryModel;
    });
  }

  void reload(int id, int level) async {
    selectedCategory = null;
    listParentId.removeRange(level, listParentId.length);
    listParentId.add(id);
    count = 0;
    Widget temp = await getCategoryList();
    setState(() {
      categoryWidgetList = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background_grey,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Strings.chooseProductCategory,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                  Text(
                    Strings.longPressToSelectCategory,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(10),
                    child: categoryWidgetList,
                  ),
                ],
              ),
            ),
            selectedCategory == null
                ? SizedBox()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Product(
                            isNewProduct: true,
                            productCategoryId:
                                selectedCategory.productCategoryId,
                          );
                        }));
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: AppTheme.green),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCategory.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Text(
                                  Strings.proceed,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    vendorDatabaseProvider.open();

    reload(0, 0);
  }

  @override
  void dispose() {
//    vendorDatabaseProvider.close();
    super.dispose();
  }
}

class Label extends StatelessWidget {
  final ProductCategoryModel productCategoryModel;
  final bool isDown;
  final Function reload;
  final int level;
  final Function select;

  Label(
      {this.isDown,
      this.reload,
      this.level,
      this.productCategoryModel,
      this.select});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              reload(productCategoryModel.productCategoryId, level);
            },
            onLongPress: () {
              select(productCategoryModel);
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    productCategoryModel.name,
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  isDown
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        )
                      : Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Divider(
            thickness: 2,
            height: 5,
            color: AppTheme.background_grey,
          )
        ],
      ),
    );
  }
}

class CategoryLabelList extends StatefulWidget {
  final List<ProductCategoryModel> productCategoryModelList;
  final Widget widget;
  final int parentId;
  final Function reload;
  final int level;
  final int selectedId;
  final Function select;

  CategoryLabelList(
      {this.productCategoryModelList,
      this.widget,
      this.parentId,
      this.reload,
      this.level,
      this.selectedId,
      this.select});

  @override
  _CategoryLabelListState createState() => _CategoryLabelListState();
}

class _CategoryLabelListState extends State<CategoryLabelList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.productCategoryModelList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Label(
              reload: widget.reload,
              isDown:
                  widget.productCategoryModelList[index].productCategoryId ==
                      widget.parentId,
              level: widget.level,
              productCategoryModel: widget.productCategoryModelList[index],
              select: widget.select,
            ),
            widget.productCategoryModelList[index].productCategoryId ==
                    widget.parentId
                ? Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: widget.widget,
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}

//indb();
//productCategoryModelList.add(ProductCategoryModel(
//1,
//1,
//'Clothing',
//0,
//'clothing,kapde,tshirt',
//false,
//true,
//'',
//true,
//false,
//4,
//));
//productCategoryModelList.add(ProductCategoryModel(
//2, 2, 'Home Furnishing', 0, 'home', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//3, 3, 'Kitchen', 0, 'kitchen', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//4, 18, 'Bathroom', 0, 'kitchen', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//5, 19, 'Curtains', 0, 'kitchen', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//6, 7, 'Grocery', 0, 'grocery', true, false, '', true, false, 1));
//productCategoryModelList.add(ProductCategoryModel(
//7, 4, 'Jeans', 1, 'jeans', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//8, 5, 'Tshirt', 1, 'tshirt', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//9, 6, 'Pant', 1, 'Pant', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//10, 8, 'Bedsheets', 2, 'Bed', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//11, 9, 'Pillow', 2, 'Pillow', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//12, 10, 'Cooker', 3, 'Cooker', false, true, '', true, false, 4));
//productCategoryModelList.add(ProductCategoryModel(
//13, 11, 'Potato', 7, 'aalu', true, false, '', true, false, 1));
//productCategoryModelList.add(ProductCategoryModel(
//14, 12, 'Onion', 7, 'pyaaz', true, false, '', true, false, 1));
//productCategoryModelList.add(ProductCategoryModel(
//15, 20, 'Half Jeans', 4, 'pyaaz', true, false, '', true, false, 1));
//productCategoryModelList.add(ProductCategoryModel(
//16, 21, 'Torn Jeans', 4, 'pyaaz', true, false, '', true, false, 1));
//productCategoryModelList.add(ProductCategoryModel(17, 22, 'Half Torn Jeans',
//21, 'pyaaz', true, false, '', true, false, 1));
//for (ProductCategoryModel productCategoryModel
//in productCategoryModelList) {
//vendorDatabaseProvider.insertProductCategory(productCategoryModel);
//}
