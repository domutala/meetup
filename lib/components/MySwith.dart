import 'package:credit_card/utils/colors.dart';
import 'package:flutter/material.dart';

class MySwitchController {
  bool value;
  MySwitchController({required this.value});
}

class MySwitch extends StatefulWidget {
  final MySwitchController? controller;
  final Color activeColor;
  final Color? inactiveColor;
  final Function(bool)? onChange;
  MySwitch({
    this.controller,
    this.activeColor = Colors.cyan,
    this.inactiveColor,
    this.onChange,
  });

  @override
  _MySwitchState createState() => _MySwitchState(
        controller: this.controller,
        activeColor: this.activeColor,
        inactiveColor: this.inactiveColor ?? Colors.black.withAlpha(70),
        onChange: this.onChange,
      );
}

class _MySwitchState extends State<MySwitch> {
  final MySwitchController? controller;
  final Color activeColor;
  final Color inactiveColor;
  final Function(bool)? onChange;

  _MySwitchState({
    this.controller,
    required this.activeColor,
    required this.inactiveColor,
    this.onChange,
  });
  bool _value = false;

  @override
  void initState() {
    super.initState();

    if (this.controller != null) {
      setState(() => _value = this.controller!.value);
      if (onChange != null) onChange!(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _value = !_value);
        if (this.controller != null) {
          setState(() => this.controller!.value = _value);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 20,
            width: 45,
            decoration: BoxDecoration(
              color: _value ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            top: -5,
            left: _value ? 15 : 0,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _value ? activeColor : inactiveColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: xDark,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
