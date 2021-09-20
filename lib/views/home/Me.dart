import 'package:credit_card/interfaces/User.dart';
import 'package:credit_card/utils/colors.dart';
import 'package:credit_card/utils/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class VHomeMe extends StatefulWidget {
  @override
  _VHomeMeState createState() => _VHomeMeState();
}

class _VHomeMeState extends State<VHomeMe> {
  late IUser me;
  @override
  void initState() {
    super.initState();

    setState(() {
      me = IUser(
        id: 0,
        name: 'Matar',
        birthDay: '1997-05-20',
        photos: ['assets/images/me.png'],
        distance: 16,
        ages: [18, 30],
        description: "",
        phone: "+2213459803",
      );
    });
  }

  Widget box(
      {required String title, required String value, bool clickable = false}) {
    return Container(
      constraints: BoxConstraints(minHeight: 80),
      margin: EdgeInsets.only(top: 5, left: 30, right: 30),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        color: xLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: xDark.withOpacity(.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: TextStyle(
              color: xDark.withOpacity(.5),
              fontSize: 12,
              height: 1,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 5),
          Container(
            // width: 250,
            child: Text(
              '$value',
              style: TextStyle(
                color: xDark,
                fontSize: 16,
                height: 1,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: xLight),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                SizedBox(height: 100),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: xLight,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipOval(
                    child: Image(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/images/me.png'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    '${me.name}, ${calcAge(me.birthDay)}',
                    style: TextStyle(
                      color: xDark,
                      fontSize: 22,
                      height: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  child: box(
                      title: 'Votre nom', value: '${me.name}', clickable: true),
                  onTap: openNameUpdate,
                ),
                GestureDetector(
                  onTap: () async {
                    var nDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse('${me.birthDay}'),
                      firstDate: DateTime(DateTime.now().year - 118),
                      lastDate: DateTime(DateTime.now().year - 18),
                      builder: (cntx, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: xPrimary,
                            accentColor: xPrimary,
                            colorScheme: ColorScheme.light(
                              primary: xPrimary,
                            ),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: Container(child: child),
                        );
                      },
                    );

                    if (nDate != null) {
                      setState(() {
                        me.birthDay = foratDate(
                            date: nDate.toString(), format: 'yyyy-MM-dd');
                      });
                    }
                  },
                  child: box(
                    title: 'Date de naissance',
                    value: '${foratDate(date: me.birthDay)}',
                    clickable: true,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(minHeight: 80),
                  margin: EdgeInsets.only(top: 5, left: 30, right: 30),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: xLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: xDark.withOpacity(.1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'distance: ${me.distance.floor()} km',
                          style: TextStyle(
                            color: xDark.withOpacity(.5),
                            fontSize: 12,
                            height: 1,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Slider(
                        value: me.distance,
                        min: 1,
                        max: 100,
                        divisions: 99,
                        activeColor: xPrimary,
                        inactiveColor: xPrimary.withOpacity(.3),
                        label: "${me.distance}",
                        onChanged: (v) {
                          setState(
                            () {
                              me.distance = v.floorToDouble();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(minHeight: 80),
                  margin: EdgeInsets.only(top: 5, left: 30, right: 30),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: xLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: xDark.withOpacity(.1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'ages: ${me.ages[0].floor()} à ${me.ages[1].floor()} ans',
                          style: TextStyle(
                            color: xDark.withOpacity(.5),
                            fontSize: 12,
                            height: 1,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      RangeSlider(
                        values: RangeValues(me.ages[0], me.ages[1]),
                        min: 18,
                        max: 100,
                        activeColor: xPrimary,
                        inactiveColor: xPrimary.withOpacity(.3),
                        divisions: 100 - 18,
                        labels: RangeLabels(
                          '${me.ages[0].floor()}',
                          '${me.ages[1].floor()}',
                        ),
                        onChanged: (v) {
                          setState(() {
                            me.ages[0] = v.start.floorToDouble();
                            me.ages[1] = v.end.floorToDouble();
                          });
                        },
                      )
                    ],
                  ),
                ),
                box(title: 'Téléphone', value: '${me.phone}'),
                GestureDetector(
                  onTap: openDescriptionUpdate,
                  child: box(
                    title: 'Description',
                    value:
                        '${me.description != null && me.description!.isNotEmpty ? me.description : 'Aucune description'}',
                    clickable: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 45,
            color: xLight,
          ),
        ),
      ],
    );
  }

  openNameUpdate() {
    showMenu(
      child: UpdateName(
        name: me.name,
        onSave: (name) {
          Navigator.of(context).pop();
          setState(() {
            me.name = name;
          });
        },
      ),
    );
  }

  openDescriptionUpdate() {
    showMenu(
      child: UpdateDescription(
        name: me.description ?? '',
        onSave: (description) {
          Navigator.of(context).pop();
          setState(() {
            me.description = description;
          });
        },
      ),
    );
  }

  showMenu({required Widget child}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Theme.of(context).primaryColorDark.withOpacity(.2),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: child,
          ),
        );
      },
    );
  }
}

class UpdateName extends StatefulWidget {
  final String name;
  final Function(String name) onSave;
  UpdateName({required this.name, required this.onSave});

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: xDark, width: .1),
    borderRadius: new BorderRadius.circular(10.0),
  );
  String _name = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _name = widget.name;
      _controller.text = _name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Material(
        borderRadius: new BorderRadius.circular(5.0),
        color: xLight,
        child: TextField(
          autofocus: true,
          maxLength: 25,
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Votre nom',
            labelStyle: TextStyle(
              color: xDark,
            ),
            filled: true,
            fillColor: xDark.withOpacity(0.05),
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(end: 12.0),
              child: GestureDetector(
                onTap: () {
                  if (_name.isNotEmpty) widget.onSave(_name);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          _name.isNotEmpty ? xPrimary : xDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.check, color: xLight, size: 16),
                  ),
                ),
              ),
            ),
          ),
          keyboardType: TextInputType.text,
          style: TextStyle(color: xDark),
          onChanged: (v) {
            setState(() {
              _name = v;
            });
          },
        ),
      ),
    );
  }
}

class UpdateDescription extends StatefulWidget {
  final String name;
  final Function(String name) onSave;
  UpdateDescription({required this.name, required this.onSave});

  @override
  _UpdateDescriptionState createState() => _UpdateDescriptionState();
}

class _UpdateDescriptionState extends State<UpdateDescription> {
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: xTransparent, width: 0),
  );
  String _name = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _name = widget.name;
      _controller.text = _name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: new BorderRadius.circular(5.0),
            color: xLight,
            child: TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Description',
                labelStyle: TextStyle(
                  color: xDark,
                ),
                filled: true,
                fillColor: xDark.withOpacity(0.05),
                enabledBorder: border,
                border: border,
                focusedBorder: border,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              style: TextStyle(color: xDark),
              onChanged: (v) {
                setState(() {
                  _name = v;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onSave(_name);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 30,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Text('Enregistrer', style: TextStyle(color: xLight)),
                        Icon(Icons.check, color: xLight, size: 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
