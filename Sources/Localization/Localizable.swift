/// A macro that generates a localized `String` property for `enum` cases, using the enum cases as localization keys.
///
/// The macro enables convenient localization handling by converting each `enum` case into a key that matches the format
/// used in your `.localizable` files. The format of the keys can be customized using the `keyFormat` argument.
///
/// ### Key Formatting
/// The `keyFormat` argument allows you to specify how the enum cases should be transformed into localization keys:
/// - `.camelCase` (default): Converts cases to camelCase (e.g., `myExampleCase` becomes `myExampleCase`).
/// - `.lowerSnakeCase`: Converts cases to lower_snake_case (e.g., `myExampleCase` becomes `my_example_case`).
/// - `.upperSnakeCase`: Converts cases to UPPER_SNAKE_CASE (e.g., `myExampleCase` becomes `MY_EXAMPLE_CASE`).
///
/// ### Associated Values
/// Associated values in `enum` cases simplify the formatting of localized strings by mapping directly to arguments for
/// `String(format:)`. Each associated value is passed as a parameter in the generated `localized` property.
///
/// ### Usage
/// You can apply the macro to any `enum` and optionally specify the `keyFormat` to customize the localization key generation.
///
/// #### Example 1: Default Key Format (`.camelCase`)
/// ```swift
/// @Localizable
/// enum Localization {
///     case ok
///     case welcomeMessage(userName: String)
///     case totalAmount(items: Int, price: Double)
/// }
/// ```
///
/// Expansion:
/// ```swift
/// @Localizable
/// enum Localization {
///     case ok
///     case welcomeMessage(userName: String)
///     case totalAmount(items: Int, price: Double)
///
///     public var localized: String {
///         switch self {
///         case .ok:
///             localized("ok")
///         case let .welcomeMessage(userName):
///             String(format: localized("welcomeMessage"), userName)
///         case let .totalAmount(items, price):
///             String(format: localized("totalAmount"), items, price)
///         }
///     }
///
///     private func localized(_ string: String) -> String {
///         NSLocalizedString(string, comment: "")
///     }
/// }
/// ```
///
/// #### Example 2: Custom Key Format (`.upperSnakeCase`)
/// ```swift
/// @Localizable(keyFormat: .upperSnakeCase)
/// enum Localization {
///     case helloWorld
///     case itemCount(count: Int)
/// }
/// ```
///
/// Expansion:
/// ```swift
/// @Localizable(keyFormat: .upperSnakeCase)
/// enum Localization {
///     case helloWorld
///     case itemCount(count: Int)
///
///     public var localized: String {
///         switch self {
///         case .helloWorld:
///             localized("HELLO_WORLD")
///         case let .itemCount(count):
///             String(format: localized("ITEM_COUNT"), count)
///         }
///     }
///
///     private func localized(_ string: String) -> String {
///         NSLocalizedString(string, comment: "")
///     }
/// }
/// ```
///
/// ### Notes
/// - **Best Practice:** While it's ideal to use a single main localization enum, breaking down localizations into
///   multiple enums (e.g., for alerts or specific screens) can help maintain a clean structure.
/// - **KeyFormat Default:** If no `keyFormat` is specified, the macro defaults to `.camelCase`.
///
/// ### Declaration
/// ```swift
/// @attached(member, names: arbitrary)
/// public macro Localizable(keyFormat: LocalizationKeyFormat = .camelCase)
/// ```
///
/// ### Supported Key Formats
/// ```swift
/// public enum LocalizationKeyFormat {
///     case camelCase
///     case lowerSnakeCase
///     case upperSnakeCase
/// }
/// ```
@attached(member, names: arbitrary)
public macro Localizable(keyFormat: LocalizationKeyFormat = .camelCase) = #externalMacro(module: "LocalizationMacros", type: "LocalizableMacro")

/// Represents the available formats for transforming enum cases into localization keys.
///
/// The `LocalizationKeyFormat` enum defines how the names of `enum` cases are converted into string keys for use in localization files.
/// This allows flexibility in adapting the key format to match the naming conventions used in the localization system.
///
/// ### Available Formats:
/// - **`camelCase`**: Enum cases are transformed into camelCase keys (e.g., `exampleCase` becomes `exampleCase`).
/// - **`lowerSnakeCase`**: Enum cases are transformed into lower_snake_case keys (e.g., `exampleCase` becomes `example_case`).
/// - **`upperSnakeCase`**: Enum cases are transformed into UPPER_SNAKE_CASE keys (e.g., `exampleCase` becomes `EXAMPLE_CASE`).
///
/// This enum is used as an argument in the `Localizable` macro to customize the key format.
public enum LocalizationKeyFormat {
    
    /// Transforms enum cases into `camelCase` keys.
    ///
    /// Example:
    /// ```swift
    /// case exampleCase -> "exampleCase"
    /// ```
    case camelCase
    
    /// Transforms enum cases into `lower_snake_case` keys.
    ///
    /// Example:
    /// ```swift
    /// case exampleCase -> "example_case"
    /// ```
    case lowerSnakeCase
    
    /// Transforms enum cases into `UPPER_SNAKE_CASE` keys.
    ///
    /// Example:
    /// ```swift
    /// case exampleCase -> "EXAMPLE_CASE"
    /// ```
    case upperSnakeCase
}
