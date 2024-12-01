import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main()
{
  late Database db;

  setUp(() async
  {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async
  {
    await db.close();
  });

  group('DB Unit Tests', ()
  {
    test('Check DB Version', () async {
      var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      expect(await db.getVersion(), 0);
      await db.close();
    });

    test('Insertion Test', () async {
      await db.execute('CREATE TABLE Task (id INTEGER PRIMARY KEY,todo TEXT, userId INTEGER, completed TEXT, type TEXT)');

      await db.insert('Task', {'id': 1, 'todo':'my unit test todo 1', 'userId':1, 'completed': 'false', 'type':'user'});
      await db.insert('Task', {'id': 2, 'todo':'my unit test todo 2', 'userId':2, 'completed': 'true', 'type':'user'});

      var result = await db.rawQuery('SELECT id,todo FROM TASK');
      expect(result, [
        {'id': 1, 'todo': 'my unit test todo 1'},
        {'id': 2, 'todo': 'my unit test todo 2'}
      ]);
    });

    test('Update Test', () async {
      await db.execute('CREATE TABLE Task (id INTEGER PRIMARY KEY,todo TEXT, userId INTEGER, completed TEXT, type TEXT)');

      await db.insert('Task', {'id': 1, 'todo':'my unit test todo 1', 'userId':1, 'completed': 'false', 'type':'user'});

      var result = await db.rawQuery('SELECT completed FROM TASK WHERE ID = 1');
      expect(result, [{'completed':'false'}]);

      await db.rawUpdate('UPDATE Task SET completed = ? WHERE ID = ?', ['true',1]);

      result = await db.rawQuery('SELECT completed FROM TASK WHERE ID = 1');
      expect(result, [{'completed':'true'}]);
    });

  });
}