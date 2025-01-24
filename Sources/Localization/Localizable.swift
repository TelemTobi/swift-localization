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

public enum LocalizationKeyFormat {
    case camelCase
    case lowerSnakeCase
    case upperSnakeCase
}
