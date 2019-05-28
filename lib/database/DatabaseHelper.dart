import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Playlist{
  int _id;
  String _title;

  // Constructors
  Playlist(this._title);
  Playlist.withID(this._id);

  int get id => _id;
  String get title => _title;
  set title(String newTitle){
    this._title=newTitle;
  }

  // Convert a Playlist object to a Map object
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    return map;
  }

  // Extract a playlist object from a map object
  Playlist.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
  }
}

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String playlistTable = 'playlist_table';
  String colID = 'id';
  String colTitle = 'title';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'playlist.db';

    var playlistDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return playlistDatabase;
  }

  void _createDB(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $playlistTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT)');
  }
  
  // Fetch Operation
  Future<List<Map<String, dynamic>>> getPlaylistList() async{
    Database db = await this.database;
    var result = await db.query(playlistTable, orderBy: '$colID ASC');
    return result;
  }

  // Insert Operation
  Future<int> insertPlaylist(Playlist playlist) async{
    Database db = await this.database;
    var result = await db.insert(playlistTable, playlist.toMap());
    return result;
  }

  // Update Operation
  Future<int> updatePlaylist(Playlist playlist) async{
    var db = await this.database;
    var result = await db.update(playlistTable, playlist.toMap(), where: '$colID = ?', whereArgs: [playlist.id]);
    return result;
  }

  // Delete Operation
  Future<int> deletePlaylist(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $playlistTable WHERE $colID = $id');
    return result;
  }

  // Get Playlist Count
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $playlistTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }


}