/// Classes representing simple domain models (events and data)

class DomainEventKeys {
  // starts platform specific processing
  static const String start = 'start';
  // processing is in progress
  static const String processing = 'processing';
  // processing is finished successfully
  static const String success = 'success';
  // processing is finished with error
  static const String error = 'error';
}

/// Enum representing domain event keys
enum DomainEvent { start, processing, success, error }

/// Class representing a simple domain data model
class DomainDataKeys {
  static const String id = 'id';
}
