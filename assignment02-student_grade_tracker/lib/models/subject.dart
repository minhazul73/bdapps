class Subject {
  final String name;
  final double _mark;

  Subject(this.name, this._mark);

  /// Factory constructor for creating a new `Subject` instance from a map.
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      json['name'] as String,
      (json['mark'] as num).toDouble(),
    );
  }

  /// Converts this `Subject` instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mark': _mark,
    };
  }

  /// Getter for the private [_mark] field.
  double get mark => _mark;

  /// Grade getter:
  /// - A (≥80)
  /// - B (≥65)
  /// - C (≥50)
  /// - F otherwise
  String get grade {
    if (_mark >= 80) {
      return 'A';
    } else if (_mark >= 65) {
      return 'B';
    } else if (_mark >= 50) {
      return 'C';
    } else {
      return 'F';
    }
  }
}
