import XCTest
@testable import ProtectedData

class Dummy {}

final class SafetyTests: XCTestCase {
  var base: Dummy!
  var notificationCenter: NotificationCenter!

  override func setUpWithError() throws {
    base = Dummy()
    notificationCenter = NotificationCenter()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testProtectedDataAvailable_GivenFalse_WhenProtectedDataAvailable_ThenReturnTrue() async throws {
    let safety = Safety(base, notificationCenter: notificationCenter, protectedDataAvailable: { false })
    
    let expected = true
    
    let name = await UIApplication.protectedDataDidBecomeAvailableNotification
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
      self.notificationCenter.post(name: name, object: nil)
    }.fire()
    let actual = await safety.protectedDataAvailable(timeout: 1_000)
    
    XCTAssertEqual(expected, actual)
  }
  
  func testProtectedDataAvailable_GivenFalse_WhenProtectedDataNotAvailableUntilTimeout_ThenReturnFalse() async throws {
    let safety = Safety(base, notificationCenter: notificationCenter, protectedDataAvailable: { false })
    
    let expected = false
    let actual = await safety.protectedDataAvailable(timeout: 1)
        
    XCTAssertEqual(expected, actual)
  }
  
  func testProtectedDataAvailable_GivenTrue_ThenReturnTrue() async throws {
    let safety = Safety(base, notificationCenter: notificationCenter, protectedDataAvailable: { true })
    
    let expected = true
    let actual = await safety.protectedDataAvailable(timeout: 1)
        
    XCTAssertEqual(expected, actual)
  }
  
  func testProtectedDataAvailable_GivenTrue_WhenProtectedDataWillBecomeAvailableBeforeCall_ThenReturnFalse() async throws {
    let safety = Safety(base, notificationCenter: notificationCenter, protectedDataAvailable: { true })
    
    await notificationCenter.post(name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
    
    let expected = false
    let actual = await safety.protectedDataAvailable(timeout: 2)
        
    XCTAssertEqual(expected, actual)
  }
}
