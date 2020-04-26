class User {

  int id;
  String _eventName;
  String _eventLocation;
  String _eventST;
  String _eventET;
  String _eventCAT;
  String _eventDate;
  User(this._eventName, this._eventLocation, this._eventST, this._eventET,this._eventCAT,this._eventDate);

  User.map(dynamic obj) {
    this._eventName = obj["eventname"];
    this._eventLocation = obj["eventloc"];
    this._eventST = obj["stime"];
    this._eventET = obj["etime"];
    this._eventCAT = obj["category"];
    this._eventDate = obj["date"];
  }

  String get eventName => _eventName;

  String get eventLocation => _eventLocation;

  String get eventST => _eventST;

  String get eventET => _eventET;

  String get eventCAT => _eventCAT;

  String get eventDate => _eventDate;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["eventname"] = _eventName;
    map["eventloc"] = _eventLocation;
    map["stime"] = _eventST;
    map["etime"] = _eventET;
    map["category"] = _eventCAT;
    map["date"] = _eventDate;
    return map;
  }

  void setUserId(int id) {
    this.id = id;
  }
}
