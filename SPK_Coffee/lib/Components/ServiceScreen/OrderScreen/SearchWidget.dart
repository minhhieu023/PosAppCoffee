// import 'package:SPK_Coffee/Models/Product.dart';
// import 'package:flutter/material.dart';
// import 'package:search_widget/search_widget.dart';

// class SearcProductWidget extends StatelessWidget {
//   final List<Products> list;
//   const SearcProductWidget({this.list, Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: SearchWidget<Products>(
//       dataList: list,
//       hideSearchBoxWhenItemSelected: false,
//       listContainerHeight: MediaQuery.of(context).size.height / 4,
//       queryBuilder: (String query, List<Products> list) {
//         return list
//             .where((Products item) =>
//                 item.productName.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       },
//       popupListItemBuilder: (Products item) {
//         return PopupListItemWidget(item);
//       },
//       selectedItemBuilder:
//           (Products selectedItem, VoidCallback deleteSelectedItem) {
//         return SelectedItemWidget(selectedItem, deleteSelectedItem);
//       },
//       // widget customization
//       noItemsFoundWidget: Text("Item not found"),
//       textFieldBuilder:
//           (TextEditingController controller, FocusNode focusNode) {
//         return MyTextField(controller, focusNode);
//       },
//     ));
//   }
// }
