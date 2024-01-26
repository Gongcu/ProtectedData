import UIKit
import Combine

extension UserDefaults: SafetyStorage {}

extension Safety where Base: UserDefaults {
  public func object(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Any? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.object(forKey: defaultName)
  }
  
  public func set(_ value: Any?, forKey defaultName: String, timeout seconds: Double = .infinity) async throws  {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.set(value, forKey: defaultName)
  }
  
  public func removeObject(forKey defaultName: String, timeout seconds: Double = .infinity) async throws {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.removeObject(forKey: defaultName)
  }
  
  public func string(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> String? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.string(forKey: defaultName)
  }
  
  public func array(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> [Any]? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.array(forKey: defaultName)
  }
  
  public func dictionary(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> [String : Any]? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.dictionary(forKey: defaultName)
  }
  
  public func data(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Data? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.data(forKey: defaultName)
  }
  
  public func stringArray(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> [String]? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.stringArray(forKey: defaultName)
  }
  
  public func integer(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Int {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.integer(forKey: defaultName)
  }
  
  public func float(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Float {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.float(forKey: defaultName)
  }
  
  public func double(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Double {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.double(forKey: defaultName)
  }
  
  public func bool(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> Bool {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.bool(forKey: defaultName)
  }
  
  public func url(forKey defaultName: String, timeout seconds: Double = .infinity) async throws -> URL? {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    return self.base.url(forKey: defaultName)
  }

  public func set(_ value: Any, forKey defaultName: String, timeout seconds: Double = .infinity) async throws {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    self.base.set(value, forKey: defaultName)
  }
  
  public func register(defaults registrationDictionary: [String : Any], timeout seconds: Double = .infinity) async throws {
    guard await self.protectedDataAvailable(timeout: seconds) else { throw SafetyError.timeout }
    self.base.register(defaults: registrationDictionary)
  }
}
