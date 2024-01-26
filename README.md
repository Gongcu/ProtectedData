# Protected Data
It aids in the process of handling data by waiting for the protected data to become available without blocking.

## Installation

### Swift Package Manager
File > Swift Packages > Add Package Dependency
Add https://github.com/Gongcu/ProtectedData.git


## Example
Use UserDefaults with `.safe`

```swift
let userDefaults = UserDefaults.standard

userDefaults.safe.set("value", forKey: "key")

let value = userDefaults.safe.string(forKey: "key")
```
