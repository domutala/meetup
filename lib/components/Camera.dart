import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:credit_card/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCamera extends StatefulWidget {
  MyCamera();

  @override
  _MyCameraState createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  CameraController? _cameraController;

  bool _cameraInitialized = false;
  bool _flash = false;
  String _mode = "photo";
  int _recordingVideoTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<CameraDescription> cameras = await availableCameras();
    initializeCamera(cameras.first);
  }

  initializeCamera(CameraDescription camera) async {
    _cameraController = new CameraController(
      camera,
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    try {
      _cameraController!.initialize().then((_) {
        setState(() {
          _cameraInitialized = true;
          _cameraController!.setFlashMode(
            _flash ? FlashMode.auto : FlashMode.off,
          );
        });
      });
    } catch (e) {}
  }

  switchCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    var direction = _cameraController!.description.lensDirection;
    CameraDescription? newDescription;

    if (direction == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    initializeCamera(newDescription);
  }

  takePicture() {
    if (!_cameraController!.value.isTakingPicture) {
      setState(() {
        _cameraController!.takePicture().then((value) {});
      });
    }
  }

  startRecordingVideo() {
    if (!_cameraController!.value.isRecordingVideo) {
      setState(() {
        _cameraController!.startVideoRecording();
        _recordingVideoTime = 0;
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_cameraController!.value.isRecordingVideo) {
          if (!_cameraController!.value.isRecordingPaused) {
            setState(() {
              _recordingVideoTime++;
            });
          }
        } else {
          _timer!.cancel();
        }
      });
    }
  }

  pauseOrPlayVideoRecording() {
    if (_cameraController!.value.isRecordingPaused == false) {
      setState(() {
        _cameraController!.pauseVideoRecording();
      });
    } else {
      setState(() {
        _cameraController!.resumeVideoRecording();
      });
    }
  }

  stopVideoRecording() {
    if (_cameraController!.value.isRecordingVideo) {
      setState(() {
        _cameraController!.stopVideoRecording().then((value) {});
      });
    }
  }

  get formatRecordingVideoTime {
    var duration = Duration(seconds: _recordingVideoTime);

    // if (dur.inSeconds <= 59) {
    //   return '${dur.inSeconds}';
    // }

    // if (dur.inMinutes <= 59) {

    //   dur.inMinutes;
    // }

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  Widget cameraBuilder() {
    return Container(
      child: _cameraInitialized
          ? CameraPreview(
              _cameraController!,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 50,
                    right: 30,
                    child: Container(
                      child: !_cameraController!.value.isRecordingVideo
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_flash)
                                        _cameraController!
                                            .setFlashMode(FlashMode.off);
                                      else
                                        _cameraController!
                                            .setFlashMode(FlashMode.auto);

                                      _flash = !_flash;
                                    });
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _flash
                                            ? Icons.flash_on
                                            : Icons.flash_off,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: switchCamera,
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.flip_camera_android,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 30, right: 30),
                              child: Text(
                                '$formatRecordingVideoTime',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: !_cameraController!.value.isRecordingVideo
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _mode = 'photo'),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _mode == 'photo'
                                                ? xLight
                                                : xTransparent,
                                          ),
                                        ),
                                        child: Text(
                                          'Photo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: xLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _mode = 'video'),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _mode == 'video'
                                                ? xLight
                                                : xTransparent,
                                          ),
                                        ),
                                        child: Text(
                                          'Vidéo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: xLight,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : null,
                        ),
                        Container(
                          child: !_cameraController!.value.isRecordingVideo
                              ? GestureDetector(
                                  onTap: () {
                                    if (_mode == 'video')
                                      startRecordingVideo();
                                    else
                                      takePicture();
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: _mode == 'video'
                                          ? Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.red,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: pauseOrPlayVideoRecording,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _cameraController!
                                                    .value.isRecordingPaused
                                                ? Icons.play_arrow
                                                : Icons.pause,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: stopVideoRecording,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 50),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: xLight,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return cameraBuilder();
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
