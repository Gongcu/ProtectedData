// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "ProtectedData",
  platforms: [.iOS(.v13), .macCatalyst(.v13), .macOS(.v10_13), .tvOS(.v12), .watchOS(.v7)],
  products: [
    .library(
      name: "ProtectedData",
      targets: ["ProtectedData"]
    ),
  ],
  targets: [
    .target(
      name: "ProtectedData",
      path: "ProtectedData/"
    )
  ]
)
