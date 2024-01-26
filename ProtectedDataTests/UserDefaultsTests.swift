import XCTest
import Combine
@testable import ProtectedData

class UserDefaultsTests: XCTestCase {
  var sut: UserDefaults!
  
  override func setUpWithError() throws {
    sut = UserDefaults.standard
  }
  
  override func tearDownWithError() throws {
    sut.dictionaryRepresentation().keys.forEach { key in
      sut.removeObject(forKey: key)
    }
  }
  func testSetAndGetAndRemoveObject() async throws {
    let key = "object"
    let saveValue = 1
    try await sut.safe.set(saveValue, forKey: key)
    let value = try await sut.safe.object(forKey: key) as? Int
    XCTAssertEqual(value, saveValue)
    
    try await sut.safe.removeObject(forKey: key)
    let remove = try await sut.safe.object(forKey: key)
    XCTAssertNil(remove)
  }
  
  func testSetAndGetString() async throws {
    let key = "string"
    let saveValue = "1"
    try await sut.safe.set(saveValue, forKey: key)
    let value = try await sut.safe.string(forKey: key)
    XCTAssertEqual(value, saveValue)
  }
  
  func testSetAndGetInteger() async throws {
    let key = "int"
    let saveValue = 1
    try await sut.safe.set(saveValue, forKey: key)
    let value = try await sut.safe.integer(forKey: key)
    XCTAssertEqual(value, saveValue)
  }
  
  func testSetAndGetArray() async throws {
    let key = "array"
    let saveValue = [1,2,3]
    try await sut.safe.set(saveValue, forKey: key)
    let value = try await sut.safe.array(forKey: key) as? [Int]
    XCTAssertEqual(value, saveValue)
  }
  
  func testSetAndGetDictionary() async throws {
    let key = "dict"
    let saveValue = ["x": "y"]
    try await sut.safe.set(saveValue, forKey: key)
    let value = try await sut.safe.dictionary(forKey: key)
    XCTAssertEqual(value?["x"] as? String, saveValue["x"])
    XCTAssertEqual(value?.count, saveValue.count)
  }
}
