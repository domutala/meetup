import 'package:credit_card/components/CreditCardContainer.dart';
import 'package:credit_card/utils/profils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VHomeSwitch extends StatefulWidget {
  final TextEditingController pulledBottomController;
  VHomeSwitch({required this.pulledBottomController});

  @override
  _VHomeSwitchState createState() => _VHomeSwitchState(
        pulledBottomController: pulledBottomController,
      );
}

class _VHomeSwitchState extends State<VHomeSwitch> {
  final TextEditingController pulledBottomController;
  _VHomeSwitchState({required this.pulledBottomController});

  int _currentProfil = 0;
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    for (var i = 0; i < profils.length; i++) {
      setState(() {
        widgets.add(CreditCardContainer(
          next: next,
          profil: profils[i],
          onPulling: onPulling,
          isCurrent: _currentProfil == i,
        ));
      });
    }
  }

  onPulling({
    required bool pulled,
    required double pullHeight,
    required double verticalDragDistance,
  }) {
    double p = verticalDragDistance * 100 / pullHeight;
    double t = 100 / 100 * p;
    try {
      setState(() => pulledBottomController.text = (0 + t).toString());
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: widgets,
              ),
            ),
          ),
        ),
      ],
    );
  }

  next() {
    if (_currentProfil < 3) {
      setState(() {
        widgets.removeLast();
      });
    }
  }
}
