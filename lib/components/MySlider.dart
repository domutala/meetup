import 'package:credit_card/utils/colors.dart';
import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  final double width;
  final double start;
  final double end;
  final double? min;
  final double? max;
  final double? initLeft;
  final double? initRight;
  final bool floor;
  final String direction;

  MySlider({
    this.width = 300,
    this.start = 0,
    this.end = 100,
    this.min,
    this.max,
    this.initLeft,
    this.initRight,
    this.floor = true,
    this.direction = 'right',
  });

  @override
  _MySliderState createState() => _MySliderState(
        width: width,
        start: start,
        end: end,
        min: min,
        max: max,
        initLeft: initLeft,
        initRight: initRight,
        floor: floor,
        direction: direction,
      );
}

class _MySliderState extends State<MySlider> {
  double width;
  double start;
  double end;
  double? min;
  double? max;
  double? initLeft;
  double? initRight;
  bool floor;
  String direction;

  _MySliderState({
    required this.width,
    required this.start,
    required this.end,
    this.min,
    this.max,
    this.initLeft,
    this.initRight,
    this.floor = true,
    this.direction = 'right',
  });

  double _min = 0;
  double _max = 0;

  String? _horizontalDragSart;

  double rButtonPosition = 0;
  double lButtonPosition = 0;
  double _rRight = 0;
  double _lRight = 0;

  @override
  void initState() {
    super.initState();

    if (min != null)
      setState(() => _min = min!);
    else
      setState(() => _min = start);

    if (max != null)
      setState(() => _max = max!);
    else
      setState(() => _max = end);

    if (end < start) setState(() => end = start + 1);
    if (_min < start) setState(() => _min = start);
    if (_max > end) setState(() => _max = end);

    if (direction == 'both' || direction == 'right') {
      double p2 = (_min * 100 / (end - start)) - start;
      double dist = width * p2 / 100;
      setState(() => lButtonPosition = dist);
      setState(() => rButtonPosition = dist);
    } else {
      double p2 = _max * 100 / (end - start);
      double dist = width * p2 / 100;
      setState(() => lButtonPosition = dist);
      setState(() => rButtonPosition = dist);
    }

    if (initLeft != null) {
      double p2 = initLeft! * 100 / (end - start);
      double dist = width * p2 / 100;
      setState(() => lButtonPosition = dist);
    }
    if (initRight != null) {
      double p2 = initRight! * 100 / (end - start);
      double dist = width * p2 / 100;
      setState(() => rButtonPosition = dist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: (darg) => onHorizontalDragEnd(),
      onHorizontalDragCancel: () => onHorizontalDragEnd(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            height: 20,
            alignment: Alignment.centerLeft,
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: _horizontalDragSart != null ? double.infinity : 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: xPrimary.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: lButtonPosition,
                    width: rButtonPosition - lButtonPosition + 20,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (['both', 'left'].contains(direction))
            Positioned(
              top: 0,
              left: lButtonPosition > width - 20
                  ? lButtonPosition - 20
                  : lButtonPosition,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: xPrimary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: xDark,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _horizontalDragSart == 'left'
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -20,
                            child: Text(
                              '$_lRight',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.none,
                                color: xDark,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          if (['both', 'right'].contains(direction))
            Positioned(
              top: 0,
              left: rButtonPosition > width - 20
                  ? rButtonPosition - 20
                  : rButtonPosition,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: xPrimary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: xDark,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _horizontalDragSart == 'right'
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -20,
                            child: Text(
                              '$_rRight',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.none,
                                color: xDark,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  onHorizontalDragStart(drag) {
    double dx = drag.globalPosition.dx;
    setState(() => _horizontalDragSart = null);

    if (direction == 'both') {
      if (dx < lButtonPosition) {
        setState(() => _horizontalDragSart = 'left');
        setState(() => lButtonPosition = dx);
        onDrag();
      } else if (dx > rButtonPosition) {
        setState(() => _horizontalDragSart = 'right');
        setState(() => rButtonPosition = dx);
        onDrag2();
      } else {
        double r = (rButtonPosition - dx).abs();
        double l = (dx - lButtonPosition).abs();

        if (l > r) {
          setState(() => _horizontalDragSart = 'right');
          setState(() => rButtonPosition = dx);
          onDrag2();
        } else {
          setState(() => _horizontalDragSart = 'left');
          setState(() => lButtonPosition = dx);
          onDrag();
        }
      }
    } else if (direction == 'left') {
      setState(() => _horizontalDragSart = 'left');
      setState(() => lButtonPosition = dx);
      onDrag();
    } else {
      setState(() => _horizontalDragSart = 'right');
      setState(() => rButtonPosition = dx);
      onDrag2();
    }
  }

  onHorizontalDragUpdate(drag) {
    double dx = drag.globalPosition.dx;
    if (_horizontalDragSart == 'left') {
      setState(() => lButtonPosition = dx);
      onDrag();
    } else if (_horizontalDragSart == 'right') {
      setState(() => rButtonPosition = dx);
      onDrag2();
    }
  }

  onHorizontalDragEnd() {
    setState(() => _horizontalDragSart = null);
  }

  onDrag() {
    if (lButtonPosition < 0)
      setState(() => lButtonPosition = 0);
    else if (lButtonPosition > rButtonPosition)
      setState(() => lButtonPosition = rButtonPosition);

    double l = end - start;
    double p = lButtonPosition * 100 / width;
    double dist = l * p / 100;
    setState(() => _lRight = dist);

    if (dist < _min) {
      double p1 = _min * 100 / l;
      double dist1 = width * p1 / 100;
      setState(() => lButtonPosition = dist1);
      setState(() => _lRight = _min);
    } else if (dist > _max) {
      double p1 = _max * 100 / l;
      double dist1 = width * p1 / 100;
      setState(() => lButtonPosition = dist1);
      setState(() => _lRight = _max);
    }

    setState(() => _lRight = double.parse(_lRight.toStringAsFixed(2)));
    if (floor) setState(() => _lRight = _lRight.floorToDouble());
  }

  onDrag2() {
    if (rButtonPosition > width)
      setState(() => rButtonPosition = width);
    else if (rButtonPosition < lButtonPosition)
      setState(() => rButtonPosition = lButtonPosition);

    double l = end - start;
    double p = rButtonPosition * 100 / width;
    double dist = l * p / 100;
    setState(() => _rRight = dist);

    if (dist > _max) {
      double p1 = _max * 100 / l;
      double dist1 = width * p1 / 100;
      setState(() => rButtonPosition = dist1);
      setState(() => _rRight = _max);
    } else if (dist < _min) {
      double p1 = _min * 100 / l;
      double dist1 = width * p1 / 100;
      setState(() => rButtonPosition = dist1);
      setState(() => _rRight = _min);
    }

    setState(() => _rRight = double.parse(_rRight.toStringAsFixed(2)));
    if (floor) setState(() => _rRight = _rRight.floorToDouble());
  }
}
