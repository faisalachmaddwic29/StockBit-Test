import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnKey = 'key';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnPending = 'isPending';

class AlarmSqflite {
  Database? _database;

  Future<Database?> get database async {
    // if (_database == null) {
    //   _database = await initalizeDatabase();
    // }
    _database ??= await initalizeDatabase();

    return _database;
  }

  Future<Database> initalizeDatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, 'alarm.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('''
        CREATE TABLE $tableAlarm(
          $columnId integer primary key autoincrement,
          $columnKey integer text not null,
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer)
        ''');
    });

    return database;
  }

  Future<int> insertAlarm(AlarmModel? alarmModel) async {
    var db = await database;

    var result = db!.insert(tableAlarm, alarmModel!.toMap());
    return result;
  }

  Future<List<AlarmModel>> getAlarms() async {
    List<AlarmModel> _alarms = [];

    var db = await database;
    var result = await db!.query(tableAlarm);
    if (result.isNotEmpty) {
      for (var element in result) {
        var alarmInfo = AlarmModel.fromJson(element);
        _alarms.add(alarmInfo);
      }
      _alarms.sort((a, b) =>
          a.alarmDateTime.toString().compareTo(b.alarmDateTime.toString()));
    }
    // _alarms.forEach((object) {
    //   print("datetime: ${object.alarmDateTime}"); // prints: barName: foo
    //   print("id: ${object.id}"); // prints: latitudeDbRef: bar
    //   print("pending: ${object.isPending}"); // prints: latitudeDbRef: bar
    // });
    return _alarms;
  }

  Future<int> updateAlarm(AlarmModel? alarmModel) async {
    var db = await database;
    // print(db);
    // print('ini dari update: ${alarmModel!.isPending}');
    // print('ini dari id: ${alarmModel.id}');

    // return await db!.update(tableAlarm, alarmModel.toMap(),
    //     where: '$columnId = ?', whereArgs: [alarmModel.id]);

    return await db!.update(tableAlarm, alarmModel!.toMap(),
        where: '$columnId = ?', whereArgs: [alarmModel.id]);
  }

  Future<int> deleteAlarm(int? id) async {
    var db = await database;
    return await db!
        .delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> getLength() async {
    var db = await database;
    var result = await db!.query(tableAlarm);

    return result.length;
  }

  Future<bool> deleteDb() async {
    bool databaseDeleted = false;

    try {
      String dir = await getDatabasesPath();
      String path = join(dir, 'alarm.db');
      await deleteDatabase(path).whenComplete(() {
        databaseDeleted = true;
      }).catchError((onError) {
        databaseDeleted = false;
      });
      // ignore: unused_catch_clause
    } on DatabaseException catch (error) {
      // print(error);
    } catch (error) {
      // print(error);
    }

    return databaseDeleted;
  }

  Future closeDb() async {
    var dbClient = await database;
    dbClient!.close();
  }
}
