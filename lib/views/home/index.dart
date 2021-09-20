import 'package:credit_card/utils/colors.dart';
import 'package:credit_card/utils/store.dart';
import 'package:credit_card/views/home/Me.dart';
import 'package:credit_card/views/home/match.dart';
import 'package:credit_card/views/home/switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VHome extends StatefulWidget {
  @override
  _VHomeState createState() => _VHomeState();
}

class _VHomeState extends State<VHome> with SingleTickerProviderStateMixin {
  double _footBottomPosition = 0;
  TextEditingController pulledBottomController = TextEditingController();
  TextEditingController sideController = TextEditingController(text: 'switch');

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    initStore();
    _controller = TabController(vsync: this, length: 3, initialIndex: 1);

    _controller.addListener(() {
      setState(() {
        changeTo(_controller.index);
      });
    });

    pulledBottomController.addListener(() {
      try {
        setState(() {
          _footBottomPosition = double.parse(pulledBottomController.text);
        });
      } catch (e) {}
    });
  }

  void changeTo(int index) {
    setState(() {
      _controller.animateTo(index);
    });
  }

  Widget menu() {
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
                    color: _controller.index == 0 ? xPrimary : xDark,
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
                  color: _controller.index == 1 ? xPrimary : xDark,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: xDark.withOpacity(.1),
                    width: 3,
                  ),
                ),
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
                    color: _controller.index == 2 ? xPrimary : xDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: xPrimary.withOpacity(.1)),
            Container(
              child: TabBarView(
                controller: _controller,
                children: [
                  VHomeMatch(),
                  VHomeSwitch(
                    pulledBottomController: pulledBottomController,
                  ),
                  VHomeMe(),
                ],
              ),
            ),
            Positioned(
              bottom: -_footBottomPosition - 5,
              left: 0,
              right: 0,
              child: menu(),
            )
          ],
        ),
      ),
    );
  }
}
