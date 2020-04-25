class Course {

  int id;
  String _courseId;
  String _courseName;
  String _courseVenue;
  String _eventST;
  String _eventET;
  String _eventCAT;
  String _teachingWeek;
  String _courseType;
  String _academicUnit;
  String _name;

  Course(this._courseId,this._courseName, this._courseVenue, this._eventST, this._eventET,this._eventCAT,this._teachingWeek,this._courseType,this._academicUnit,this._name);

  Course.map(dynamic obj) {
    this._courseId = obj["courseid"];
    this._courseName = obj["coursename"];
    this._courseVenue = obj["coursevenue"];
    this._eventST = obj["stime"];
    this._eventET = obj["etime"];
    this._eventCAT = obj["category"];
    this._teachingWeek = obj["week"];
    this._courseType = obj["coursetype"];
    this._academicUnit = obj["academicunit"];
    this._name = obj["name"];
  }

  String get courseId => _courseId;

  String get courseName => _courseName;

  String get courseVenue => _courseVenue;

  String get eventST => _eventST;

  String get eventET => _eventST;

  String get eventCAT => _eventCAT;

  String get teachingWeek => _teachingWeek;

  String get courseType => _courseType;

  String get academicUnit => _academicUnit;

  String get name => _name;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["courseid"] = _courseId;
    map["coursename"] = _courseName;
    map["coursevenue"] = _courseVenue;
    map["stime"] = _eventST;
    map["etime"] = _eventET;
    map["category"] = _eventCAT;
    map["week"] = _teachingWeek;
    map["coursetype"] = _courseType;
    map["academicunit"] = _academicUnit;
    map["name"] = _name;
    return map;
  }

  void setCourseId(int id) {
    this.id = id;
  }
}
