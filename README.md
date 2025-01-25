# Swift Localization

A Swift macro-powered package that simplifies string localization in your iOS, macOS, and other Apple platform applications. It provides a type-safe, maintainable, and elegant way to handle localizations using Swift enums.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- ✨ Type-safe localization using Swift enums
- 🔧 Customizable key formatting (camelCase, snake_case, or UPPER_SNAKE_CASE)
- 💪 Compile-time validation
- 🎯 Support for string interpolation with associated values

## Installation

Add this package to your project using Swift Package Manager by adding it to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/telemtobi/swift-localization.git", from: "1.0.0")
]
```

## Quick Start

1. Create an enum and annotate it with `@Localizable`:

```swift
import Localization

@Localizable
enum Strings {
    case welcome(name: String)
    case itemCount(count: Int)
    case totalPrice(amount: Double)
}
```

2. Use it in your code:

```swift
let welcomeText = Strings.welcome(name: "John").localized
let itemCountText = Strings.itemCount(count: 5).localized
let priceText = Strings.totalPrice(amount: 99.99).localized
```

3. Add corresponding keys to your `Localizable.strings` file:

```
"welcome" = "Welcome, %@!";
"itemCount" = "You have %d items";
"totalPrice" = "Total: $%.2f";
```

## Key Formatting

You can customize how the enum cases are converted to localization keys using the `keyFormat` parameter:

```swift
@Localizable(keyFormat: .camelCase)
enum Strings { // Default: welcomeMessage -> "welcomeMessage"
    case welcomeMessage
}

@Localizable(keyFormat: .lowerSnakeCase)
enum Strings { // welcomeMessage -> "welcome_message"
    case welcomeMessage
}

@Localizable(keyFormat: .upperSnakeCase)
enum Strings { // welcomeMessage -> "WELCOME_MESSAGE"
    case welcomeMessage
}
```

### Using Associated Values

Associated values in enum cases are automatically mapped to format arguments in your localized strings:

```swift
@Localizable
enum Alerts {
    case deleteConfirmation(itemName: String)
    case syncProgress(completed: Int, total: Int)
}

// Localizable.strings
"deleteConfirmation" = "Are you sure you want to delete %@?";
"syncProgress" = "Synced %d out of %d items";

// Usage
let alert = Alerts.deleteConfirmation(itemName: "Document").localized
let progress = Alerts.syncProgress(completed: 5, total: 10).localized
```

## String Extensions

To make your localized strings even more convenient to use, you can add extensions to `String` and `LocalizedStringKey`. This allows for a more natural and SwiftUI-friendly syntax:

```swift
extension String {
    static func localized(_ string: Strings) -> Self {
        string.localized
    }
}

extension LocalizedStringKey {
    static func localized(_ string: Strings) -> Self {
        .init(string.localized)
    }
}
```

Now you can use your localizations in an even more elegant way:

```swift
label.text = .localized(.welcome(name: "John"))

Text(.localized(.welcome(name: "John")))
```

This approach:
- Makes your code more readable and concise
- Provides better type safety
- Works seamlessly with both UIKit and SwiftUI
- Maintains the type-safe benefits of your localization enums

## Requirements

- Swift 5.9 or later
- Xcode 15.0 or later
- iOS 13.0 / macOS 10.15 / tvOS 13.0 / watchOS 6.0 or later

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
