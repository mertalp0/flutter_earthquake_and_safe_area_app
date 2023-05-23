import 'package:contacts_service/contacts_service.dart';
import '../database/database_helper.dart';
import '../models/directory_model.dart';

class EmergencyRepository {
  final DatabaseHelper dbHelper;

  EmergencyRepository(this.dbHelper);

  Future<List<Directory>> getPersons() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows.map((row) => Directory.fromMap(row)).toList();
  }

  Future<void> addPerson(Contact selectedContact) async {
    final displayName = selectedContact.displayName;
    final phoneNumber = selectedContact.phones?.first.value;
    final person = Directory(name: displayName, phone: phoneNumber);
    
    await dbHelper.insert(person);
  }

  Future<void> deletePerson(int personId) async {
    await dbHelper.delete(personId);
  }
  Future<bool> isPersonExists(String displayName, String phoneNumber) async {
    final persons = await getPersons();
    return persons.any((person) =>
        person.name == displayName && person.phone == phoneNumber);
  }
}
