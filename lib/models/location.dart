class Location {
  double _latitude;
  double _longitude;
  String _userId;
  String _description;

  String get userId => _userId;
  set userId(String value){
    _userId = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  Location(this._latitude, this._longitude);
}