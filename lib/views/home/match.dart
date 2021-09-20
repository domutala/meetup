import 'package:credit_card/components/Camera.dart';
import 'package:credit_card/components/Contact.dart';
import 'package:credit_card/components/MediaSelecter.dart';
import 'package:credit_card/utils/colors.dart';
import 'package:credit_card/utils/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VHomeMatch extends StatefulWidget {
  @override
  _VHomeMatchState createState() => _VHomeMatchState();
}

class _VHomeMatchState extends State<VHomeMatch> {
  String _messageText = '';
  ScrollController _scrollController = ScrollController();

  var messages = [
    {
      'from': 'me',
      'messages': [
        {'date': '10:47', 'content': 'Salut', 'from': 'me'},
        {'date': '10:47', 'content': 'Comment tu vas ?', 'from': 'me'}
      ],
    },
    {
      'from': '0001',
      'messages': [
        {
          'date': '10:47',
          'content': 'Oui, salut toi, je vais bien',
          'from': 'me'
        },
        {'date': '10:47', 'content': 'Et toi nakamu ?', 'from': 'me'}
      ],
    },
    {
      'from': 'me',
      'messages': [
        {
          'date': '10:47',
          'content':
              'Once your Android app has been registered, download the configuration file from the Firebase Console (the file is called google-services.json). Add this file into the android/app directory within your Flutter project.',
          'from': 'me'
        },
        {'date': '10:47', 'content': 'Kesk t\'en dit ?', 'from': 'me'}
      ],
    },
    {
      'from': '0001',
      'messages': [
        {
          'date': '10:47',
          'content': 'Je suis d\'accords avec toi',
          'from': 'me'
        },
        {'date': '10:47', 'content': 'On a qu`\'à le faire', 'from': 'me'},
        {'date': '10:47', 'content': 'Demain !', 'from': 'me'},
      ],
    },
    {
      'from': 'me',
      'messages': [
        {'date': '10:47', 'content': 'ok c\'est bon', 'from': 'me'}
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget buildPart(dynamic message) {
    var widget = Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: EdgeInsets.only(right: 10, top: 3),
            decoration: BoxDecoration(
              color: xDark.withOpacity(.1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: ClipOval(
              child: Image(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/7.png'),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var m = 0; m < message['messages'].length; m++)
                Container(
                  margin: EdgeInsets.only(top: 2),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: xPrimary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15),
                      topLeft:
                          m == 0 ? Radius.circular(15) : Radius.circular(5),
                      bottomLeft: m == message['messages'].length - 1
                          ? Radius.circular(15)
                          : Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    '${message['messages'][m]['content']}',
                    style: TextStyle(color: xLight),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    return widget;
  }

  Widget buildPart2(dynamic message) {
    var widget = Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var m = 0; m < message['messages'].length; m++)
              Container(
                margin: EdgeInsets.only(top: 2),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: xDark.withOpacity(.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: m == 0 ? Radius.circular(15) : Radius.circular(5),
                    bottomRight: m == message['messages'].length - 1
                        ? Radius.circular(15)
                        : Radius.circular(5),
                  ),
                ),
                child: Text(
                  '${message['messages'][m]['content']}',
                  style: TextStyle(color: xDark),
                ),
              ),
          ],
        ),
      ),
    );
    return widget;
  }

  Widget editor() {
    InputBorder border = InputBorder.none;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: xLight,
        border: Border(
          top: BorderSide(
            color: xDark.withOpacity(.1),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        decoration: BoxDecoration(
          color: xDark.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Votre message...',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: xDark.withOpacity(.5),
                    ),
                    labelStyle: TextStyle(
                      color: xDark,
                    ),
                    filled: false,
                    enabledBorder: border,
                    border: border,
                    focusedBorder: border,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  style: TextStyle(
                    color: xDark,
                    height: 1.2,
                  ),
                  onChanged: (v) {
                    setState(() {
                      _messageText = v;
                    });
                  },
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_messageText.isNotEmpty) {
                      setState(() {
                        (messages.last['messages'] as List).add({
                          'date': '10:47',
                          'content': '$_messageText',
                          'from': 'me'
                        });
                        _messageText = '';
                      });
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      _messageText.isEmpty ? FontAwesomeIcons.plus : Icons.send,
                      color: xLight,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      FontAwesomeIcons.microphone,
                      color: xLight,
                      size: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTop() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: xLight,
        boxShadow: [
          BoxShadow(
            color: xPrimary.withOpacity(.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: xLight,
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipOval(
                child: Image(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/7.png'),
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Marie',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: xLight),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTop(),
                Flexible(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var i = 0; i < messages.length; i++)
                              messages[i]['from'] == 'me'
                                  ? buildPart2(messages[i])
                                  : buildPart(messages[i])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Editor(context: context),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Editor extends StatefulWidget {
  final BuildContext context;
  const Editor({Key? key, required this.context}) : super(key: key);

  @override
  _EditorState createState() => _EditorState(context: context);
}

class _EditorState extends State<Editor> {
  final BuildContext context;
  _EditorState({required this.context});

  String _messageText = '';
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool get keyboardVisiblity {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  addElement() {
    Widget btn({required Widget icon}) {
      return Container(
        child: Center(
          child: Container(
            width: 64,
            height: 64,
            child: Center(
              child: icon,
            ),
          ),
        ),
      );
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: xDark.withOpacity(.001),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: xLight,
                border: Border(
                  top: BorderSide(
                    color: xDark.withOpacity(.1),
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                constraints: BoxConstraints(maxWidth: 300),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          openCamera();
                        },
                        child: btn(
                          icon: SvgPicture.asset(
                            'assets/icons/video-camera.svg',
                            width: 32,
                          ),
                        ),
                      ),
                      btn(
                        icon: SvgPicture.asset(
                          'assets/icons/file.svg',
                          width: 32,
                        ),
                      ),
                      GestureDetector(
                        onTap: openContact,
                        child: btn(
                          icon: SvgPicture.asset(
                            'assets/icons/notebook-of-contacts.svg',
                            width: 32,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: openMedias,
                        child: btn(
                          icon: SvgPicture.asset(
                            'assets/icons/vertical.svg',
                            width: 32,
                          ),
                        ),
                      ),
                      btn(
                        icon: SvgPicture.asset(
                          'assets/icons/headphones.svg',
                          width: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  openCamera() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: xTransparent,
      backgroundColor: xLight,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [MyCamera()],
        );
      },
    );
  }

  openContact() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: xTransparent,
      backgroundColor: xLight,
      builder: (context) {
        return MyContact();
      },
    );
  }

  openMedias() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: xTransparent,
      backgroundColor: xLight,
      builder: (context) {
        return MediaSelecter();
      },
    );
  }

  Widget buildTextEditor() {
    InputBorder border = InputBorder.none;
    TextField textField = TextField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Votre message...',
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: xDark.withOpacity(.5),
        ),
        labelStyle: TextStyle(
          color: xDark,
        ),
        filled: false,
        enabledBorder: border,
        border: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 6,
      style: TextStyle(
        color: xDark,
        height: 1.2,
      ),
      controller: _textEditingController,
      onChanged: (v) => setState(() => _messageText = v),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: textField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: xLight,
        border: Border(
          top: BorderSide(
            color: xDark.withOpacity(.1),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        decoration: BoxDecoration(
          color: xDark.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: buildTextEditor(),
            ),
            Container(
              child: !keyboardVisiblity
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: addElement,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: xPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: xLight,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: xPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              FontAwesomeIcons.microphone,
                              color: xLight,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _messageText.isEmpty
                              ? xDark.withOpacity(.2)
                              : xPrimary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.send,
                          color: xLight,
                          size: 16,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
