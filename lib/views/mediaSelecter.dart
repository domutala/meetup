import 'dart:async';
import 'dart:typed_data';

import 'package:credit_card/components/Camera.dart';
import 'package:credit_card/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

class VMediaSelecter extends StatefulWidget {
  final bool multiple;
  VMediaSelecter({this.multiple = false});

  @override
  _VMediaSelecterState createState() =>
      _VMediaSelecterState(multiple: this.multiple);
}

class _VMediaSelecterState extends State<VMediaSelecter> {
  final bool multiple;
  _VMediaSelecterState({required this.multiple});

  bool _verticalDragSart = false;
  double _verticalDragSartTo = 0;
  double _verticalDragDistance = 0;

  bool _pulled = false;
  double _pullHeight = 200;

  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _album;
  List<AssetEntity> _assets = [];
  List<AssetEntity> _assetsChoices = [];
  int _currentAssetChoice = 0;

  Size get mediaSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() => _albums = []);

    final permitted = await PhotoManager.requestPermission();
    if (!permitted) return;

    final albums = await PhotoManager.getAssetPathList();
    setState(() => _albums = albums);

    if (albums.isEmpty) return;

    if (albums.length > 2)
      choiceAlbum(albums[1]);
    else
      choiceAlbum(albums.first);
  }

  choiceAlbum(AssetPathEntity album) async {
    setState(() => _album = album);
    setState(() => _assets = []);
    var assets = await album.getAssetListRange(start: 0, end: album.assetCount);

    setState(() => _assets = assets);
  }

  selectAlbum() {
    showModalBottomSheet(
      isScrollControlled: false,
      elevation: 0,
      context: context,
      barrierColor: Theme.of(context).primaryColorDark.withOpacity(.6),
      backgroundColor: xTransparent,
      builder: (context) {
        return Container(
          height: 500,
          alignment: Alignment.bottomCenter,
          child: Container(
            color: xLight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var album in _albums) button(album),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  onVerticalDragStart(drag) {
    var dy = drag.globalPosition.dy;
    setState(() => _verticalDragSart = true);
    setState(() => _verticalDragSartTo = dy);
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
  }

  onVerticalDragEnd() {
    setState(() => _verticalDragSart = false);

    if (_verticalDragDistance.abs() > 100) {
      setState(() => _verticalDragDistance = _pullHeight);
      setState(() => _pulled = true);
    } else {
      setState(() => _pulled = false);
      setState(() => _verticalDragDistance = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          topBuilder(),
          bottomBuilder(),
        ],
      ),
    );
  }

  Widget button(AssetPathEntity album) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        choiceAlbum(album);
      },
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            "${album.name}",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.normal,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget topBuilder() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: _assetsChoices.isEmpty
            ? MyCamera()
            : Stack(
                fit: StackFit.expand,
                children: [
                  for (var i = 0; i < _assetsChoices.length; i++)
                    Visibility(
                      visible: _currentAssetChoice == i,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          new AssetThumbnail(
                            key: Key(_assetsChoices[_currentAssetChoice].id),
                            asset: _assetsChoices[_currentAssetChoice],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (_currentAssetChoice > 0)
                                setState(() => _currentAssetChoice--);
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
                              if (_currentAssetChoice + 1 <
                                  _assetsChoices.length)
                                setState(() => _currentAssetChoice++);
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
                      child: _assetsChoices.length > 1
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 0;
                                      i < _assetsChoices.length;
                                      i++)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: Container(
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                          color: _currentAssetChoice == i
                                              ? xPrimary
                                              : xPrimary.withOpacity(.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _assetsChoices.removeAt(_currentAssetChoice);

                          _currentAssetChoice > 0
                              ? _currentAssetChoice--
                              : _currentAssetChoice = 0;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: xLight,
                          boxShadow: [
                            BoxShadow(
                              color: xDark.withOpacity(.2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.trash,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: xLight,
                          boxShadow: [
                            BoxShadow(
                              color: xDark.withOpacity(.2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget bottomBuilder() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AspectRatio(
        aspectRatio: (4 - (_verticalDragDistance / 100)) / 3,
        child: GestureDetector(
          onVerticalDragStart: onVerticalDragStart,
          onVerticalDragUpdate: onVerticalDragUpdate,
          onVerticalDragEnd: (darg) => onVerticalDragEnd(),
          onVerticalDragCancel: () => onVerticalDragEnd(),
          child: Container(
            decoration: BoxDecoration(
              color: xLight,
              boxShadow: [
                BoxShadow(
                  color: xDark.withOpacity(.2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  child: _album != null
                      ? GestureDetector(
                          onTap: selectAlbum,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${_album!.name}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  FontAwesomeIcons.chevronDown,
                                  size: 10,
                                )
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                Flexible(
                  child: Container(
                    child: _assets.isNotEmpty
                        ? GridView.count(
                            physics: !_pulled
                                ? NeverScrollableScrollPhysics()
                                : null,
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            children: [
                              for (var asset in _assets)
                                GestureDetector(
                                  onTap: () {
                                    if (_assetsChoices
                                        .where((a) => a.id == asset.id)
                                        .isEmpty) {
                                      setState(() => _assetsChoices.add(asset));
                                      setState(() => _currentAssetChoice =
                                          _assetsChoices.length - 1);
                                    } else {
                                      var index = _assetsChoices
                                          .indexWhere((a) => a.id == asset.id);
                                      if (index != -1)
                                        setState(
                                            () => _currentAssetChoice = index);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: xTransparent,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: _assetsChoices
                                                  .where(
                                                      (a) => a.id == asset.id)
                                                  .isNotEmpty
                                              ? 4
                                              : 0,
                                          color: xPrimary,
                                          style: _assetsChoices
                                                  .where(
                                                      (a) => a.id == asset.id)
                                                  .isNotEmpty
                                              ? BorderStyle.solid
                                              : BorderStyle.none,
                                        ),
                                      ),
                                      child: AssetThumbnail(asset: asset),
                                    ),
                                  ),
                                )
                            ],
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatefulWidget {
  final AssetEntity asset;
  AssetThumbnail({Key? key, required this.asset});

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var file = await widget.asset.thumbData;
    if (file != null) {
      setState(() => _bytes = file);
    }
  }

  Future<Uint8List> thumb() async {
    var t = await widget.asset.thumbData;
    if (t != null) return t;
    return Uint8List(0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            child: _bytes != null
                ? Image.memory(
                    _bytes!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    filterQuality: FilterQuality.high,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: xDark.withOpacity(.3),
                      strokeWidth: 1,
                    ),
                  ),
          ),
        ),
        // Display a Play icon if the asset is a video
        if (widget.asset.type == AssetType.video)
          Center(
            child: Container(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
