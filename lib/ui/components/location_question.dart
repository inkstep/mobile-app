import 'package:flutter/cupertino.dart';
import 'package:inkstep/ui/components/short_text_input.dart';

class PositionQuestion extends StatelessWidget {
  const PositionQuestion({Key key, this.controller,
    this.autoScrollDuration, this.func}) : super(key: key);

  final void Function(String) func;
  final PageController controller;
  final int autoScrollDuration;

  @override
  Widget build(BuildContext context) {
    return ShortTextInput(
      controller,
      Key ('position'),
      label: 'Where on your body do you want the tattoo',
      hint: 'Lower left forearm',
      duration: autoScrollDuration,
      func: func,
    );
  }
}