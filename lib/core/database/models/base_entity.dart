abstract class BaseEntity {
  String get id; // The ID from the API (or temporary local ID if creating)

  Map<String, dynamic> toMap();
}
