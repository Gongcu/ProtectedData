import UIKit
import Combine

private let checkValueIntervalInNanoseconds: UInt64 = UInt64(0.2 * 1_000 * 1_000 * 1_000)

public class Safety<Base> {
  let base: Base
  private let notificationCenter: NotificationCenter
  private let protectedDataAvailableSubject: CurrentValueSubject<Bool, Never>
  
  init(
    _ base: Base,
    notificationCenter: NotificationCenter = NotificationCenter.default,
    protectedDataAvailable: Bool = UIApplication.shared.isProtectedDataAvailable
  ) {
    self.base = base
    self.notificationCenter = notificationCenter
    self.protectedDataAvailableSubject = CurrentValueSubject<Bool, Never>(protectedDataAvailable)
    notificationCenter.addObserver(self, selector: #selector(onAvailable), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(onUnavailable), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
  }
  
  func protectedDataAvailable(timeout seconds: Double) async -> Bool {
    guard !protectedDataAvailableSubject.value else { return true }
    let current = Date()
    while !protectedDataAvailableSubject.value, current <= current.addingTimeInterval(seconds) {
      print(protectedDataAvailableSubject.value)
      do {
        try await Task.sleep(nanoseconds: checkValueIntervalInNanoseconds)
      } catch {
        return protectedDataAvailableSubject.value
      }
    }
 
    return protectedDataAvailableSubject.value
  }
  
  @objc
  private func onAvailable() {
    protectedDataAvailableSubject.send(true)
  }
  
  @objc
  private func onUnavailable() {
    protectedDataAvailableSubject.send(false)
  }
  
  deinit {
    notificationCenter.removeObserver(self)
  }
}

public protocol SafetyStorage {
  associatedtype Base
  var safe: Safety<Base> { get set }
}

extension SafetyStorage {
  public var safe: Safety<Self> {
    get { Safety(self) }
    set {}
  }
}
