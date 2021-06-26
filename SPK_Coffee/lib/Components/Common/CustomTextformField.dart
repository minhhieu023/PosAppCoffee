import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFormField(BuildContext context,
    {@required String title,
    @required TextEditingController controller,
    String Function(String) customValidator,
    void Function(String) onChanged,
    TextInputType textInputType,
    List<TextInputFormatter> inputFormatters,
    String suffixText,
    bool isTextArea = false,
    String hintText,
    bool autoValidate = true}) {
  return Container(
      padding: EdgeInsets.only(bottom: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Crab Name
            Row(
              children: [
                Expanded(child: Container(), flex: 1),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "$title:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        )),
                    flex: 8),
                Expanded(child: Container(), flex: 1),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    // --------------- Input -----------
                    child: TextFormField(
                        inputFormatters: inputFormatters,
                        keyboardType: textInputType == null
                            ? TextInputType.text
                            : textInputType,
                        onChanged: onChanged,
                        maxLines: isTextArea != null ? (isTextArea ? 3 : 1) : 1,
                        validator: autoValidate
                            ? (customValidator == null
                                ? (value) {
                                    if (value == null || value == "") {
                                      return "This field is required";
                                    }
                                    return null;
                                  }
                                : customValidator)
                            : null,
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: hintText,
                            suffixText: suffixText,
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 25, 25, 0),
                            border: OutlineInputBorder())),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
              ],
            ),
          ]));
}
