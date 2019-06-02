import 'package:flutter/material.dart';
import 'package:inkstep/ui/components/form_element_builder.dart';

import 'long_text_input.dart';

class LongTextInputFormElement extends StatelessWidget {
  LongTextInputFormElement({
    @required this.controller,
    @required this.callback,
    @required this.label,
    @required this.hint,
    Key key,
  }) : super(key: key);

  final SubmitCallback callback;
  final PageController controller;

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return FormElementBuilder(
      builder: (context, focus, submitCallback) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).accentTextTheme.subhead,
              ),
              flex: 5,
            ),
            Spacer(flex: 1),
            Flexible(
              child: LongTextInput(
                hint: hint,
                focus: focus,
                callback: submitCallback,
              ),
              flex: 20,
            ),
          ],
        );
      },
      onSubmitCallback: callback,
      controller: controller,
      fieldKey: key,
    );
  }
}

