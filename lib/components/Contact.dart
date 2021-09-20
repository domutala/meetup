import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:credit_card/utils/contacts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyContact extends StatefulWidget {
  const MyContact({Key? key}) : super(key: key);

  @override
  _MyContactState createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  Iterable<Contact> _contacts = [];
  List<Contact> _contactsSelectionned = [];
  bool _loader = false;
  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  _getContacts({String? query}) async {
    setState(() => _loader = true);
    setState(() => _contacts = []);

    getContacts0().then((contacts) {
      setState(() => _contacts = contacts);
    }).whenComplete(() => setState(() => _loader = false));
  }

  String getDisplayContact(Contact contact) {
    if (contact.displayName != null) return contact.displayName as String;
    if (contact.phones != null && contact.phones!.isNotEmpty)
      return contact.phones!.first.value as String;
    if (contact.emails != null && contact.emails!.isNotEmpty)
      return contact.emails!.first.value as String;

    return '';
  }

  Widget buildSearch() {
    InputBorder border = InputBorder.none;
    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(.1),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Recherche',
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(.5),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            filled: false,
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,
            height: 1.2,
          ),
          onChanged: (v) {
            _getContacts(query: v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                buildSearch(),
                Flexible(
                  child: !_loader
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var contact in _contacts)
                                GestureDetector(
                                  onTap: () {
                                    selectContact(contact);
                                  },
                                  onLongPress: () {
                                    setState(() =>
                                        _contactsSelectionned.add(contact));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 56,
                                                height: 56,
                                                child: ContactThumbnail(
                                                    contact: contact),
                                              ),
                                              Container(
                                                child: _contactsSelectionned
                                                        .contains(contact)
                                                    ? Container(
                                                        width: 56,
                                                        height: 56,
                                                        color: Colors.black,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '${getDisplayContact(contact)}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                )
              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: ClipOval(
                child: Container(
                  width: 42,
                  height: 42,
                  color: Colors.black,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.arrowRight,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void selectContact(Contact contact) {
    if (_contactsSelectionned.isEmpty) {
      // return contact pressed
    } else {
      if (_contactsSelectionned.contains(contact)) {
        setState(() {
          _contactsSelectionned.remove(contact);
        });
      } else {
        setState(() {
          _contactsSelectionned.add(contact);
        });
      }
    }
  }
}

class ContactThumbnail extends StatefulWidget {
  final Contact contact;
  ContactThumbnail({Key? key, required this.contact});

  @override
  _ContactThumbnailState createState() => _ContactThumbnailState();
}

class _ContactThumbnailState extends State<ContactThumbnail> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    init();
  }

  get getDisplay {
    if (widget.contact.displayName != null &&
        widget.contact.displayName!.isNotEmpty) {
      var name = widget.contact.displayName!.split(' ').first[0];

      return name.toUpperCase();
    }

    return '';
  }

  init() async {
    var file = await ContactsService.getAvatar(widget.contact);
    if (file != null) {
      setState(() => _bytes = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black12,
            child: _bytes != null
                ? Image.memory(
                    _bytes!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    filterQuality: FilterQuality.high,
                  )
                : Center(
                    child: Text('$getDisplay'),
                  ),
          ),
        ),
      ],
    );
  }
}
