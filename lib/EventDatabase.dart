import 'dart:io';
import 'package:geofence_test/Models/GeofenceEvent.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class EventDatabase {
  static final String dbName = 'trigger_events.db';

  static Future<Database> _openDatabase() async {
    Directory appDocDir = await path.getApplicationDocumentsDirectory();
    String dbPath = [appDocDir.path, dbName].join('/');

    DatabaseFactory dbFactory = databaseFactoryIo;
    return dbFactory.openDatabase(dbPath);
  }

  static StoreRef _getStore() {
    return StoreRef.main();
  }

  static Future addEvent(GeofenceTriggerEvent event) async {
    final db = await _openDatabase();
    final store = _getStore();
    db.transaction((txn) async {
      await store.add(txn, event.toMap());
    });
  }

  static Future<List<GeofenceTriggerEvent>> getAllEvents() async {
    final db = await _openDatabase();
    final store = _getStore();

    final records = await store.find(db);
    return records.map<GeofenceTriggerEvent>((r) => GeofenceTriggerEvent.fromMap(r.value)).toList();
  }

  static Future clearAllEvents() async {
    final db = await _openDatabase();
    final store = _getStore();

    await db.transaction((txn) async {
      await store.delete(txn);
    });
  }
}