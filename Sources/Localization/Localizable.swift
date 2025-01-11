/// An enum-only macro that computes a localized `String` property, using the enum cases as the keys used in our localization files.
///
/// Each enum case is converted to upper-snake-cased petterned string, represents a localization key in the provided `.localizable` files.
/// The use of `enum` associated values simplifies the `String` formatting API, as each of them is used as an argument passed to the `String(format:)` initializer.
///
/// - NOTE: Use the macro wisely, the best practice would be using a main localization enum,
/// however breaking some localizations into separated enums might be useful in some scenarios,
/// such as localization enum for alerts only.
///
/// Usage example::
///```swift
/// @Localizable
/// enum Localization {
///     case ok
///     case myPartnerIs(partnerName: String)
///     case totalCost(firstAmount: Double, secondAmount: Double, cashierName: String)
/// }
///```
/// The macro `Localizable` after macro expansion:
///```swift
/// @Localizable
/// enum Localization {
///     case ok
///     case myPartnerIs(partnerName: String)
///     case totalCost(firstAmount: Double, secondAmount: Double, cashierName: String)
///
///     public var localized: String {
///         switch self {
///         case .ok:
///             localized("OK")
///         case let .myPartnerInfo(value0):
///             String(format: localized("MY_PARTNER_INFO"), value0)
///         case let .totalCost(value0, value1, value2):
///             String(format: localized("TOTAL_COST"), value0, value1, value2)
///         }
///     }
///
///     private func localized(_ string: String) -> String {
///         NSLocalizedString(string, comment: "")
///     }
/// }
///```
@attached(member, names: arbitrary)
public macro Localizable() = #externalMacro(module: "LocalizationMacros", type: "LocalizableMacro")
