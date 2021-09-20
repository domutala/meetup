import 'dart:convert';
import 'dart:io';

import 'package:credit_card/interfaces/User.dart';
import 'package:path_provider/path_provider.dart';

initStore() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  var file = File('${appDocDir.path}/db.json');

  try {
    await file.readAsString();
  } catch (e) {
    await file.writeAsString(jsonEncode({"images": {}}));
  }

  var u = IUser(
    id: 0,
    name: 'Matar',
    birthDay: '1997-05-20',
    photos: ['12345.png'],
    distance: 16,
    ages: [18, 30],
    description: "",
    phone: "+2213459803",
  );

  saveStore(key: 'me', value: u.toJson());
}

getStore() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  var file = File('${appDocDir.path}/db.json');
  var db = jsonDecode(file.readAsStringSync());

  return db;
}

saveStore({required String key, dynamic value}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  var file = File('${appDocDir.path}/db.json');
  var db = jsonDecode(file.readAsStringSync());

  try {
    db[key] = value;
    file.writeAsStringSync(jsonEncode(db));

    return db;
  } catch (e) {
    throw e;
  }
}
