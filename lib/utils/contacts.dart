import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

init() => askPermissions();

Future<List<Contact>> getContacts0() async {
  Iterable<Contact> _contacts =
      await ContactsService.getContacts(withThumbnails: false);
  List<Contact> _contactList = _contacts.toList();

  return _contactList;
}

loadContacts() async {
  Iterable<Contact> _contacts =
      await ContactsService.getContacts(withThumbnails: false);
  List<Contact> _contactList = _contacts.toList();
  List _contactMaps = _contactList.map((e) => e.toMap()).toList();

  String json = jsonEncode(_contactMaps);

  var path = await getApplicationDocumentsDirectory();
  var file = File('${path.path}/contacts.json');
  await file.writeAsString(json);
}

Future<List<Contact>> getContacts() async {
  var path = await getApplicationDocumentsDirectory();
  var file = File('${path.path}/contacts.json');
  var contacts = file.readAsStringSync();

  List<dynamic> json = jsonDecode(contacts);
  return json.map((e) => fromJson(e)).toList();
}

Future<void> askPermissions() async {
  PermissionStatus permissionStatus = await getContactPermission();
  if (permissionStatus == PermissionStatus.granted) loadContacts();
}

Future<PermissionStatus> getContactPermission() async {
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    return permissionStatus;
  } else {
    return permission;
  }
}

Contact fromJson(dynamic contact) {
  return Contact(
    displayName: contact['displayName'],
    givenName: contact['givenName'],
    middleName: contact['middleName'],
    prefix: contact['prefix'],
    suffix: contact['suffix'],
    familyName: contact['familyName'],
    company: contact['company'],
    jobTitle: contact['jobTitle'],
    emails: contact['emails'],
    phones: contact['phones'],
    postalAddresses: contact[''],
    birthday: contact['birthday'],
    androidAccountType: contact['androidAccountType'],
    androidAccountTypeRaw: contact['androidAccountTypeRaw'],
    androidAccountName: contact['androidAccountName'],
  );
}
