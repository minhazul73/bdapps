class Subject {
  final String name;
  final double _mark;

  Subject(this.name, this._mark);

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
