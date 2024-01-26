import UIKit
import Combine

private let checkValueIntervalInNanoseconds: UInt64 = UInt64(0.2 * 1_000 * 1_000 * 1_000)

public class Safety<Base> {
  let base: Base
  private let notificationCenter: NotificationCenter
  private let protectedDataAvailable: () -> Bool
  private lazy var protectedDataAvailableSubject: CurrentValueSubject<Bool, Never> = {
    DispatchQueue.main.sync {
      return CurrentValueSubject<Bool, Never>(protectedDataAvailable())
    }
  }()
  
  init(
    _ base: Base,
    notificationCenter: NotificationCenter = NotificationCenter.default,
    protectedDataAvailable: @escaping () -> Bool = { UIApplication.shared.isProtectedDataAvailable }
  ) {
    self.base = base
    self.notificationCenter = notificationCenter
    self.protectedDataAvailable = protectedDataAvailable
    observeProtectedDataStateChanges()
  }
  
  func protectedDataAvailable(timeout seconds: Double) async -> Bool {
    guard !protectedDataAvailableSubject.value else { return true }
    let current = Date()
    while !protectedDataAvailableSubject.value, Date() <= current.addingTimeInterval(seconds) {
      do {
        try await Task.sleep(nanoseconds: checkValueIntervalInNanoseconds)
      } catch {
        return protectedDataAvailableSubject.value
      }
    }
 
    return protectedDataAvailableSubject.value
  }
  
  private func observeProtectedDataStateChanges() {
    notificationCenter.addObserver(self, selector: #selector(onAvailable), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(onUnavailable), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
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
