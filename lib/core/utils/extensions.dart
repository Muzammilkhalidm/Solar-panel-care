/// Small generic extensions + enum (de)serialization helpers.
extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((w) => w.capitalize).join(' ');
  }

  bool get isBlank => trim().isEmpty;
}

extension DoubleX on double {
  double clampRange(double min, double max) =>
      this < min ? min : (this > max ? max : this);
}

/// Looks up an enum by its serialized name with a safe fallback.
T enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
  if (name == null) return fallback;
  for (final T v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}
