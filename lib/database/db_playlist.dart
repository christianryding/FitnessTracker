class Playlist{

  int _id;
  String _title;

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