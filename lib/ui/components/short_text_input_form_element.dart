import 'package:flutter/material.dart';
import 'package:inkstep/ui/components/form_element_builder.dart';
import 'package:inkstep/ui/components/short_text_input.dart';

class ShortTextInputFormElement extends StatelessWidget {
  ShortTextInputFormElement({
    @required this.controller,
    @required this.textController,
    @required this.label,
    @required this.hint,
    // ignore: avoid_init_to_null
    this.maxLength = null,
    Key key,
    this.keyboardType,
  }) : super(key: key);

  final PageController controller;
  final TextEditingController textController;
  final TextInputType keyboardType;

  final void Function(String) callback = (_) {};

  final String label;
  final String hint;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return FormElementBuilder(
      builder: (context, focus, submitCallback) {
        return
          ShortTextInput(
            controller: textController,
            keyboardType: keyboardType,
            maxLength: maxLength,
            hint: hint,
            label: label,
            focus: focus,
            callback: submitCallback,
          );
      },
      onSubmitCallback: callback,
      controller: controller,
      fieldKey: key,
    );
  }
}
