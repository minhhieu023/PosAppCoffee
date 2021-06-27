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

Widget numberTextFormField(
    BuildContext context, TextEditingController controller,
    {@required String title,
    String suffixText,
    String Function(String) customValidator}) {
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
                      ),
                    ),
                    flex: 8),
                Expanded(child: Container(), flex: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    // --------------- Input -----------
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          onTap: () {
                            if (controller.text.trim() == "0") {
                              controller.text = "";
                            }
                          },
                          validator: customValidator == null
                              ? (value) {
                                  if (value == null || value == "") {
                                    return "This field is required";
                                  } else if (value.contains("-")) {
                                    return "This field cannot less than zero";
                                  }
                                  if (value.contains(" ")) {
                                    return "This field cannot contain space";
                                  }
                                  if (value.contains(",") ||
                                      value.contains(".")) {
                                    return "This field cannot have ',' or '.'";
                                  }
                                  return null;
                                }
                              : customValidator,
                          keyboardType: TextInputType.number,
                          controller: controller,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.remove),
                              suffixIcon: Icon(Icons.add),
                              suffixText:
                                  suffixText != null ? suffixText : null,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 25, 25, 0),
                              border: OutlineInputBorder()),
                        ),
                        Positioned(
                            width: MediaQuery.of(context).size.width * 0.8,
                            top: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    int decreaseValue =
                                        handleChangeInputNumberInt(
                                            controller.text, "DECREASE");
                                    controller.value = TextEditingValue(
                                        text: decreaseValue.toString());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline,
                                      color: Colors.green),
                                  onPressed: () {
                                    int increaseValue =
                                        handleChangeInputNumberInt(
                                            controller.text, "INCREASE");
                                    controller.value = TextEditingValue(
                                        text: increaseValue.toString());
                                  },
                                )
                              ],
                            )),
                      ],
                    ),
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

int handleChangeInputNumberInt(String input, String type) {
  try {
    if (input.isEmpty || input == null) {
      if (type == "INCREASE") {
        return 1;
      } else {
        return 0;
      }
    }

    switch (type) {
      case "INCREASE":
        {
          return (int.parse(input) ?? 0) + 1;
        }
        break;
      case "DECREASE":
        {
          if (input == "0") {
            return 0;
          }
          return (int.parse(input) ?? 0) - 1;
        }
        break;
      default:
        return 0;
    }
  } catch (e) {
    print(e);
    return 0;
  }
}
