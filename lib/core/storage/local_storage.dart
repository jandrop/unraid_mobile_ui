/// Abstract interface for local storage operations
abstract class ILocalStorage {
  /// Get a string value by key
  Future<String?> getString(String key);
  
  /// Set a string value by key
  Future<bool> setString(String key, String value);
  
  /// Get an integer value by key
  Future<int?> getInt(String key);
  
  /// Set an integer value by key
  Future<bool> setInt(String key, int value);
  
  /// Get a boolean value by key
  Future<bool?> getBool(String key);
  
  /// Set a boolean value by key
  Future<bool> setBool(String key, bool value);
  
  /// Get a double value by key
  Future<double?> getDouble(String key);
  
  /// Set a double value by key
  Future<bool> setDouble(String key, double value);
  
  /// Get a list of strings by key
  Future<List<String>?> getStringList(String key);
  
  /// Set a list of strings by key
  Future<bool> setStringList(String key, List<String> value);
  
  /// Remove a value by key
  Future<bool> remove(String key);
  
  /// Clear all values
  Future<bool> clear();
  
  /// Check if key exists
  Future<bool> containsKey(String key);
  
  /// Get all keys
  Future<Set<String>> getKeys();
}
