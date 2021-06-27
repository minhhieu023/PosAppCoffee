import 'dart:io';

import 'package:SPK_Coffee/Models/Order.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../Product.dart';

class CashProvider with ChangeNotifier {
  Order _order;
  List<ProductsInfo> _productsInfo = [];
  double _total = 0;
  void setTotal(double value) {
    _total = value;
    notifyListeners();
  }

  double getTotal() {
    return _total;
  }

  void calulateTotal() {
    if (_order != null && _order.details.length > 0) {
      _total = 0;
      _order.details.forEach((item) {
        _total += double.parse(item.price);
      });
      notifyListeners();
    }
  }

  void setCurrentOrder(Order value) {
    _order = value;
    notifyListeners();
  }

  void setProductsInfo(List<ProductsInfo> productsInfo) {
    _productsInfo.clear();
    productsInfo.forEach((infor) {
      _productsInfo.add(infor);
    });
    notifyListeners();
  }

  Order getCurrentOrder() {
    return _order;
  }

  List<ProductsInfo> getCurrentProductsInfo() {
    return _productsInfo;
  }

  Future<void> createPDF(String amountTendered, String discount) async {
    // print("create");
    // PdfDocument document = PdfDocument();
    // final page = document.pages.add();

    // page.graphics
    //     .drawString('Bills', PdfStandardFont(PdfFontFamily.helvetica, 35));

    // PdfGrid grid = PdfGrid();
    // grid.style = PdfGridStyle(
    //     font: PdfStandardFont(PdfFontFamily.helvetica, 30),
    //     cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    // grid.columns.add(count: 5);
    // grid.headers.add(1);

    // PdfGridRow header = grid.headers[0];
    // header.cells[0].value = 'No';
    // header.cells[1].value = 'Product Name';
    // header.cells[2].value = 'Unit Price';
    // header.cells[3].value = 'Amount';
    // header.cells[4].value = 'Total';
    // int noNumber = 1;
    // PdfGridRow row = grid.rows.add();

    // _order.details.forEach((e) {
    //   row = grid.rows.add();
    //   row.cells[0].value = noNumber;
    //   row.cells[1].value = _productsInfo[noNumber - 1].productName;
    //   row.cells[2].value = e.price;
    //   row.cells[3].value = e.amount;
    //   row.cells[4].value = e.amount * int.parse(e.price);
    //   noNumber++;
    // });
    // page.graphics.drawString(
    //     'Total: $_total', PdfStandardFont(PdfFontFamily.helvetica, 20));
    // double finalTotal = _total - double.parse(discount) * _total;
    // page.graphics.drawString(
    //     'Discount: $discount', PdfStandardFont(PdfFontFamily.helvetica, 20));
    // page.graphics.drawString('Final Total: $finalTotal',
    //     PdfStandardFont(PdfFontFamily.helvetica, 20));
    // page.graphics.drawString('Amount tendered: $amountTendered',
    //     PdfStandardFont(PdfFontFamily.helvetica, 20));

    // page.graphics.drawString(
    //     'Change: ${double.parse(amountTendered) - finalTotal}',
    //     PdfStandardFont(PdfFontFamily.helvetica, 20));

    // List<int> bytes = document.save();
    // document.dispose();
    // DateTime date = DateTime.now();

    // saveAndLaunchFile(bytes, 'Order-${date.toString()}.pdf');
    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
    final PdfGrid grid = PdfGrid();
// Specify the grid column count.
    grid.columns.add(count: 5);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'No';
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Unit Price';
    headerRow.cells[3].value = 'Amount';
    headerRow.cells[4].value = "Total";

// Set header font.
    PdfFont font = await getFont(GoogleFonts.roboto());
    headerRow.style.font = font;
// Add rows to the grid.
    PdfGridRow row;

    int noNumber = 1;
    _order.details.forEach((e) {
      row = grid.rows.add();
      row.cells[0].value = noNumber.toString();
      print(_productsInfo
          .where((element) => element.id == e.productId)
          .first
          .productName);
      row.cells[1].value = _productsInfo
          .where((element) => element.id == e.productId)
          .first
          .productName;
      row.cells[2].value = e.price;
      row.cells[3].value = e.amount.toString();
      row.cells[4].value = (e.amount * int.parse(e.price)).toString();
      noNumber++;
    });
// Set grid format.
    grid.style.font = font;
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));

    List<int> bytes = document.save();
    document.dispose();

    DateTime date = DateTime.now();

    saveAndLaunchFile(bytes, 'Order-${date.toString()}.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory()).path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  Future<PdfFont> getFont(TextStyle style) async {
    //Get the external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Create an empty file to write the font data
    File file = File('${directory.path}/${style.fontFamily}.ttf');
    List<int> fontBytes;
    //Check if entity with the path exists
    if (file.existsSync()) {
      fontBytes = await file.readAsBytes();
    }
    if (fontBytes != null && fontBytes.isNotEmpty) {
      //Return the google font
      return PdfTrueTypeFont(fontBytes, 12);
    } else {
      //Return the default font
      return PdfStandardFont(PdfFontFamily.helvetica, 12);
    }
  }
}
