class Location {
  double _latitude;
  double _longitude;

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String _description;

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