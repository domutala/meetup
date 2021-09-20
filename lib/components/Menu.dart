import 'package:credit_card/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Menu extends StatefulWidget {
  final TextEditingController pulledBottomController;
  final TabController sideController;
  final Function(int index) changeTo;
  Menu({
    required this.pulledBottomController,
    required this.changeTo,
    required this.sideController,
  });

  @override
  _MenuState createState() => _MenuState(
        pulledBottomController: pulledBottomController,
        changeTo: changeTo,
        sideController: sideController,
      );
}

class _MenuState extends State<Menu> {
  final TextEditingController pulledBottomController;
  final Function(int index) changeTo;
  final TabController sideController;
  _MenuState({
    required this.pulledBottomController,
    required this.changeTo,
    required this.sideController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: xLight,
              boxShadow: [
                BoxShadow(
                  color: xPrimary.withOpacity(.1),
                  blurRadius: 2,
                  offset: Offset(0, -2),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                changeTo(0);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/chat.svg',
                    width: 26,
                    color: sideController.index == 0 ? xPrimary : xDark,
                  ),
                ),
              ),
            ),
            SizedBox(width: 40),
            GestureDetector(
              onTap: () {
                changeTo(1);
              },
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: xPrimary,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: xDark.withOpacity(.1),
                      width: 3,
                    )),
                margin: EdgeInsets.only(bottom: 16),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/stack.svg',
                    width: 24,
                    color: xLight,
                  ),
                ),
              ),
            ),
            SizedBox(width: 40),
            GestureDetector(
              onTap: () {
                changeTo(2);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/bell.svg',
                    width: 24,
                    color: sideController.index == 2 ? xPrimary : xDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
