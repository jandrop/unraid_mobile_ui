/// Abstract interface for secure storage operations (tokens, passwords, etc.)
abstract class ISecureStorage {
  /// Read a value from secure storage
  Future<String?> read(String key);
  
  /// Write a value to secure storage
  Future<void> write(String key, String value);
  
  /// Delete a value from secure storage
  Future<void> delete(String key);
  
  /// Delete all values from secure storage
  Future<void> deleteAll();
  
  /// Check if key exists in secure storage
  Future<bool> containsKey(String key);
  
  /// Get all keys from secure storage
  Future<Set<String>> getKeys();
}
