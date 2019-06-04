
import 'package:flutter/material.dart';
import 'package:inkstep/ui/components/form_element_builder.dart';

class AvailabilitySelector extends StatelessWidget {

  const AvailabilitySelector({
    Key key,
    @required this.controller,
    this.duration = 500,
    @required this.weekCallbacks})
      : super(key: key);

  final PageController controller;
  final int duration;
  final WeekCallbacks weekCallbacks;

  @override
  Widget build(BuildContext context) {
    return FormElementBuilder(
        controller: controller,
        onSubmitCallback: (_) {},
        builder: (context, focus, onSubmitCallback) {
          return Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'What days of the week are you normally available?',
                              style: Theme
                                  .of(context)
                                  .accentTextTheme
                                  .title,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _buildSwitch(
                                          context, weekCallbacks.monday,
                                          'Mon: '),
                                      _buildSwitch(
                                          context, weekCallbacks.tuesday,
                                          'Tues: '),
                                      _buildSwitch(
                                          context, weekCallbacks.wednesday,
                                          'Wed: '),
                                      _buildSwitch(
                                          context, weekCallbacks.thursday,
                                          'Thurs: '),
                                      _buildSwitch(
                                          context, weekCallbacks.friday,
                                          'Fri:'),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _buildSwitch(
                                          context, weekCallbacks.saturday,
                                          'Sat:'),
                                      _buildSwitch(
                                          context, weekCallbacks.sunday,
                                          'Sun:'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Note: You have to slide these switches, not just tap on them!',
                              style: Theme
                                  .of(context)
                                  .accentTextTheme
                                  .title,
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.75,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              controller.nextPage(
                                  duration: Duration(milliseconds: duration),
                                  curve: Curves.ease);
                            },
                            elevation: 15.0,
                            padding: EdgeInsets.fromLTRB(
                                32.0, 16.0, 32.0, 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Next!', style: TextStyle(
                                fontSize: 20.0, fontFamily: 'Signika'),
                            ),
                          ),
                        ],

                      ),
                    )
                  ])
          );
        }
    );
  }

  Widget _buildSwitch(BuildContext context, SingleDayCallbacks dayCallbacks,
      String day) {
    final bool initial = dayCallbacks.currentValue();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(day, style: Theme
            .of(context)
            .accentTextTheme
            .title,),

        Switch(
          value: initial,
          onChanged: dayCallbacks.onSwitched,
          inactiveTrackColor: Theme
              .of(context)
              .primaryColor,
        ),
      ],
    );
  }
}

class WeekCallbacks {
  WeekCallbacks(
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  );

  final SingleDayCallbacks monday;
  final SingleDayCallbacks tuesday;
  final SingleDayCallbacks wednesday;
  final SingleDayCallbacks thursday;
  final SingleDayCallbacks friday;
  final SingleDayCallbacks saturday;
  final SingleDayCallbacks sunday;

}

class SingleDayCallbacks{
  SingleDayCallbacks(
      this.onSwitched,
      this.currentValue);

  final BoolCallback onSwitched;
  final bool Function() currentValue;
}