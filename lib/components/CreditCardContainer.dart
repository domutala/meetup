import 'package:credit_card/interfaces/Profil.dart';
import 'package:credit_card/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScreenSize {
  double width;
  double height;
  ScreenSize({required this.width, required this.height});
}

class CreditCardContainer extends StatefulWidget {
  final Function next;
  final IProfil profil;
  final bool isCurrent;
  final Function({
    required bool pulled,
    required double pullHeight,
    required double verticalDragDistance,
  }) onPulling;

  CreditCardContainer({
    required this.next,
    required this.profil,
    required this.onPulling,
    this.isCurrent = false,
  });

  @override
  _CreditCardContainerState createState() => _CreditCardContainerState(
      next: next, profil: profil, onPulling: onPulling);
}

class _CreditCardContainerState extends State<CreditCardContainer> {
  final Function next;
  final IProfil profil;
  final bool isCurrent;
  final Function({
    required bool pulled,
    required double pullHeight,
    required double verticalDragDistance,
  }) onPulling;

  _CreditCardContainerState({
    required this.next,
    required this.profil,
    required this.onPulling,
    this.isCurrent = false,
  });

  int _currentPhoto = 0;

  bool _pulled = false;
  double _pullHeight = 340;

  double _rotate = 0;
  Alignment _alignment = Alignment.bottomRight;
  bool _horizontalDragSart = false;
  double _horizontalDragSartTo = 0;

  bool _verticalDragSart = false;
  double _verticalDragSartTo = 0;
  double _verticalDragDistance = 0;

  @override
  void initState() {
    super.initState();
    _onPulling();
  }

  Size get mediaSize => MediaQuery.of(context).size;

  ScreenSize get screenSize {
    var size = new ScreenSize(
      width: mediaSize.width,
      height: mediaSize.height, //- kBottomNavigationBarHeight,
    );

    return size;
  }

  double get width {
    double width = 310;
    if (width > screenSize.width) width = screenSize.width - 70;
    return width;
  }

  double get height {
    double height = 550;
    if (height > screenSize.height) height = screenSize.height - 70;
    return height;
  }

  double get widthPercent {
    return width / screenSize.width;
  }

  double get heightPercent {
    return height / screenSize.height;
  }

  double get realWidth {
    double rest = 1 - widthPercent;
    double p = (_verticalDragDistance * 100) / _pullHeight;
    double a = p * rest / 100;

    if (a > rest) a = rest;
    if (a < 0) a = 0;

    return a;
  }

  double get realHeight {
    double rest = 1 - heightPercent;
    double p = (_verticalDragDistance * 100) / _pullHeight;
    double a = p * rest / 100;

    if (a > rest) a = rest;
    if (a < 0) a = 0;
    return a;
  }

  double get realRadius {
    double p = _verticalDragDistance / _pullHeight;
    double a = 20 - p * 20;

    if (a > 20) a = 20;
    if (a < 0) a = 0;

    return a;
  }

  double get realOpacity {
    double p = _verticalDragDistance / _pullHeight;
    double a = p * 1;

    if (a > 1) a = 1;
    if (a < 0) a = 0;

    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationZ(-_rotate),
      alignment: _alignment,
      child: GestureDetector(
        // horizontalDrag
        onHorizontalDragStart: onHorizontalDragStart,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: (darg) => onHorizontalDragEnd(),
        onHorizontalDragCancel: () => onHorizontalDragEnd(),

        // verticalDrag
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: (darg) => onVerticalDragEnd(),
        onVerticalDragCancel: () => onVerticalDragEnd(),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(realRadius),
            border: Border.all(
              color: xDark.withOpacity(1 - realOpacity).withAlpha(10),
              width: 1 - realOpacity,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(realRadius),
            child: Container(
              width: (widthPercent + realWidth) * screenSize.width,
              height: (heightPercent + realHeight) * screenSize.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(realRadius),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  profilBuilder(),
                  Container(
                    child: _rotate != 0
                        ? Transform(
                            transform: Matrix4.rotationZ(_rotate),
                            alignment: _alignment,
                            child: Center(
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: _rotate.abs() * 50),
                                child: Icon(
                                  _rotate > 0
                                      ? FontAwesomeIcons.longArrowAltRight
                                      : FontAwesomeIcons.solidHeart,
                                  size: (_rotate.abs() * 250),
                                  color: _rotate > 0 ? xLight : Colors.red,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  pull(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onHorizontalDragStart(drag) {
    if (_verticalDragDistance == 0) {
      var dx = drag.globalPosition.dx;
      setState(() => _horizontalDragSart = true);
      setState(() => _horizontalDragSartTo = dx);
      setState(() => _rotate = 0);
    }
  }

  onHorizontalDragUpdate(drag) {
    if (_horizontalDragSart) {
      var dist = _horizontalDragSartTo - drag.globalPosition.dx;
      var screenWidth = mediaSize.width;
      var percent = dist * 100 / screenWidth;

      setState(() => _rotate = percent / 100);

      if (_rotate > 0)
        setState(() => _alignment = Alignment.bottomLeft);
      else
        setState(() => _alignment = Alignment.bottomRight);
    }
  }

  onHorizontalDragEnd() {
    if (_rotate.abs() >= .3) next();
    setState(() => _horizontalDragSart = false);
    setState(() => _rotate = 0);
  }

  onVerticalDragStart(drag) {
    var dy = drag.globalPosition.dy;
    setState(() => _verticalDragSart = true);
    setState(() => _verticalDragSartTo = dy);
    setState(() => _rotate = 0);
    _onPulling();
  }

  onVerticalDragUpdate(drag) {
    if (_verticalDragSart) {
      var dist = _verticalDragSartTo - drag.globalPosition.dy;

      if (!_pulled) {
        if (dist > _pullHeight) dist = _pullHeight;
        if (dist < 0) dist = 0;

        setState(() => _verticalDragDistance = dist);
      } else {
        var h = _pullHeight + dist;

        if (h > _pullHeight) h = _pullHeight;
        if (h < 0) h = 0;

        setState(() => _verticalDragDistance = h);
      }
    }

    _onPulling();
  }

  onVerticalDragEnd() {
    setState(() => _verticalDragSart = false);

    if (_verticalDragDistance.abs() > 100) {
      setState(() => _verticalDragDistance = _pullHeight);
      setState(() => _pulled = true);
    } else {
      setState(() => _verticalDragDistance = 0);
      setState(() => _pulled = false);
    }

    _onPulling();
  }

  _onPulling() {
    onPulling(
      verticalDragDistance: _verticalDragDistance,
      pulled: _pulled,
      pullHeight: _pullHeight,
    );
  }

  Widget pull() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: _verticalDragDistance + 100,
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: xLight.withOpacity(realOpacity),
            boxShadow: _pulled && _verticalDragDistance >= 300
                ? [
                    BoxShadow(
                      color: xDark.withOpacity(.1),
                      blurRadius: 2,
                      offset: Offset(0, -2), // Shadow position
                    ),
                  ]
                : [],
          ),
          child: SingleChildScrollView(
            physics: !_pulled ? NeverScrollableScrollPhysics() : null,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${profil.name}, ${profil.age}',
                        style: TextStyle(fontSize: 28, height: 1),
                      ),
                      Text(
                        '${profil.position}',
                        style:
                            TextStyle(fontSize: 13, height: 1, color: xPrimary),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: profil.description != null
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            '${profil.description}',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profilBuilder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: xLight),
        Image(
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          image: AssetImage(profil.photos[_currentPhoto]),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (_currentPhoto > 0) _currentPhoto--;
                  },
                  child: Container(
                    color: xLight.withOpacity(.00001),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (_currentPhoto + 1 < profil.photos.length)
                      _currentPhoto++;
                  },
                  child: Container(
                    color: xLight.withOpacity(.00001),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Container(
            child: profil.photos.length > 1
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < profil.photos.length; i++)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                color: _currentPhoto == i
                                    ? xPrimary
                                    : xPrimary.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
