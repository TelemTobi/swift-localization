import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LocalizationMacros)
import LocalizationMacros

let testMacros: [String: Macro.Type] = [
    "Localizable": LocalizableMacro.self
]
#endif

final class LocalizableTests: XCTestCase {
    
    func testNotAnEnumDiagnostic() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable
            struct Localization {
            }
            """,
            expandedSource:
            """
            struct Localization {
            }
            """,
            diagnostics: [
                .init(message: "'Localizable' macro can only be attached to enums", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #endif
    }
    
    func testEmptyEnum() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
                """
                @Localizable
                enum Localization {
                }
                """,
                expandedSource:
                """
                enum Localization {
                
                    public var localized: String {
                        switch self {
                        }
                    }
                
                    private func localized(_ string: String) -> String {
                        NSLocalizedString(string, comment: "")
                    }
                }
                """,
                macros: testMacros
        )
        #endif
    }
    
    // MARK: - camelCase

    func testCamelCaseConsecutiveCapitalLetters() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .camelCase)
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("a")
                    case .A:
                        localized("A")
                    case .Aa:
                        localized("Aa")
                    case .ok:
                        localized("ok")
                    case .url:
                        localized("url")
                    case .URl:
                        localized("URl")
                    case .URL:
                        localized("URL")
                    case .noIRegretted:
                        localized("noIRegretted")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testCamelCaseWithAssociatedValues() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .camelCase)
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            }
            """,
            expandedSource:
            """
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            
                public var localized: String {
                    switch self {
                    case .noValues:
                        localized("noValues")
                    case let .singleString(value0):
                        String(format: localized("singleString"), value0)
                    case let .singleInt(value0):
                        String(format: localized("singleInt"), value0)
                    case let .singleFloat(value0):
                        String(format: localized("singleFloat"), value0)
                    case let .singleDouble(value0):
                        String(format: localized("singleDouble"), value0)
                    case let .twoValues(value0, value1):
                        String(format: localized("twoValues"), value0, value1)
                    case let .twoValues2(value0, value1):
                        String(format: localized("twoValues2"), value0, value1)
                    case let .twoValues3(value0, value1):
                        String(format: localized("twoValues3"), value0, value1)
                    case let .threeValues(value0, value1, value2):
                        String(format: localized("threeValues"), value0, value1, value2)
                    case let .threeValues2(value0, value1, value2):
                        String(format: localized("threeValues2"), value0, value1, value2)
                    case let .threeValues3(value0, value1, value2):
                        String(format: localized("threeValues3"), value0, value1, value2)
                    case let .fourValues(value0, value1, value2, value3):
                        String(format: localized("fourValues"), value0, value1, value2, value3)
                    case let .fourValues2(value0, value1, value2, value3):
                        String(format: localized("fourValues2"), value0, value1, value2, value3)
                    case let .fourValues3(value0, value1, value2, value3):
                        String(format: localized("fourValues3"), value0, value1, value2, value3)
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testCamelCaseCasesWithNumbers() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .camelCase)
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("a")
                    case .a1:
                        localized("a1")
                    case .a2345:
                        localized("a2345")
                    case .ab8th9:
                        localized("ab8th9")
                    case .c0cDdd4d:
                        localized("c0cDdd4d")
                    case .ABC6:
                        localized("ABC6")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testCamelCaseWithBackticks() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .camelCase)
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            }
            """,
            expandedSource:
            """
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            
                public var localized: String {
                    switch self {
                    case .`case`:
                        localized("case")
                    case .`continue`:
                        localized("continue")
                    case .`if`:
                        localized("if")
                    case .`is`:
                        localized("is")
                    case let .`for`(value0):
                        String(format: localized("for"), value0)
                    case .`while`:
                        localized("while")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }
    
    // MARK: - upperSnakeCase

    func testUpperSnakeCaseConsecutiveCapitalLetters() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .upperSnakeCase)
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("A")
                    case .A:
                        localized("A")
                    case .Aa:
                        localized("AA")
                    case .ok:
                        localized("OK")
                    case .url:
                        localized("URL")
                    case .URl:
                        localized("U_RL")
                    case .URL:
                        localized("U_R_L")
                    case .noIRegretted:
                        localized("NO_I_REGRETTED")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testUpperSnakeCaseWithAssociatedValues() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .upperSnakeCase)
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            }
            """,
            expandedSource:
            """
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            
                public var localized: String {
                    switch self {
                    case .noValues:
                        localized("NO_VALUES")
                    case let .singleString(value0):
                        String(format: localized("SINGLE_STRING"), value0)
                    case let .singleInt(value0):
                        String(format: localized("SINGLE_INT"), value0)
                    case let .singleFloat(value0):
                        String(format: localized("SINGLE_FLOAT"), value0)
                    case let .singleDouble(value0):
                        String(format: localized("SINGLE_DOUBLE"), value0)
                    case let .twoValues(value0, value1):
                        String(format: localized("TWO_VALUES"), value0, value1)
                    case let .twoValues2(value0, value1):
                        String(format: localized("TWO_VALUES2"), value0, value1)
                    case let .twoValues3(value0, value1):
                        String(format: localized("TWO_VALUES3"), value0, value1)
                    case let .threeValues(value0, value1, value2):
                        String(format: localized("THREE_VALUES"), value0, value1, value2)
                    case let .threeValues2(value0, value1, value2):
                        String(format: localized("THREE_VALUES2"), value0, value1, value2)
                    case let .threeValues3(value0, value1, value2):
                        String(format: localized("THREE_VALUES3"), value0, value1, value2)
                    case let .fourValues(value0, value1, value2, value3):
                        String(format: localized("FOUR_VALUES"), value0, value1, value2, value3)
                    case let .fourValues2(value0, value1, value2, value3):
                        String(format: localized("FOUR_VALUES2"), value0, value1, value2, value3)
                    case let .fourValues3(value0, value1, value2, value3):
                        String(format: localized("FOUR_VALUES3"), value0, value1, value2, value3)
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }
    
    func testUpperSnakeCaseCasesWithNumbers() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .upperSnakeCase)
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("A")
                    case .a1:
                        localized("A1")
                    case .a2345:
                        localized("A2345")
                    case .ab8th9:
                        localized("AB8TH9")
                    case .c0cDdd4d:
                        localized("C0C_DDD4D")
                    case .ABC6:
                        localized("A_B_C6")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }
    
    func testUpperSnakeCaseWithBackticks() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .upperSnakeCase)
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            }
            """,
            expandedSource:
            """
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            
                public var localized: String {
                    switch self {
                    case .`case`:
                        localized("CASE")
                    case .`continue`:
                        localized("CONTINUE")
                    case .`if`:
                        localized("IF")
                    case .`is`:
                        localized("IS")
                    case let .`for`(value0):
                        String(format: localized("FOR"), value0)
                    case .`while`:
                        localized("WHILE")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    // MARK: - lowerSnakeCase

    func testLowerSnakeCaseConsecutiveCapitalLetters() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .lowerSnakeCase)
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case A
                case Aa
                case ok
                case url
                case URl
                case URL
                case noIRegretted
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("a")
                    case .A:
                        localized("a")
                    case .Aa:
                        localized("aa")
                    case .ok:
                        localized("ok")
                    case .url:
                        localized("url")
                    case .URl:
                        localized("u_rl")
                    case .URL:
                        localized("u_r_l")
                    case .noIRegretted:
                        localized("no_i_regretted")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testLowerSnakeCaseWithAssociatedValues() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .lowerSnakeCase)
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            }
            """,
            expandedSource:
            """
            enum Localization {
                case noValues
                case singleString(stringValue: String)
                case singleInt(intValue: Int)
                case singleFloat(floatValue: Float)
                case singleDouble(doubleValue: Double)
                case twoValues(first: String, second: String)
                case twoValues2(first: Double, second: Float)
                case twoValues3(first: Int, second: Int)
                case threeValues(first: String, second: Int, third: String)
                case threeValues2(first: Int, second: String, third: Double)
                case threeValues3(first: Float, second: Float, third: Int)
                case fourValues(first: String, second: Float, third: String, fourth: Double)
                case fourValues2(first: Int, second: Int, third: String, fourth: Int)
                case fourValues3(first: Float, second: Float, third: Double, fourth: Double)
            
                public var localized: String {
                    switch self {
                    case .noValues:
                        localized("no_values")
                    case let .singleString(value0):
                        String(format: localized("single_string"), value0)
                    case let .singleInt(value0):
                        String(format: localized("single_int"), value0)
                    case let .singleFloat(value0):
                        String(format: localized("single_float"), value0)
                    case let .singleDouble(value0):
                        String(format: localized("single_double"), value0)
                    case let .twoValues(value0, value1):
                        String(format: localized("two_values"), value0, value1)
                    case let .twoValues2(value0, value1):
                        String(format: localized("two_values2"), value0, value1)
                    case let .twoValues3(value0, value1):
                        String(format: localized("two_values3"), value0, value1)
                    case let .threeValues(value0, value1, value2):
                        String(format: localized("three_values"), value0, value1, value2)
                    case let .threeValues2(value0, value1, value2):
                        String(format: localized("three_values2"), value0, value1, value2)
                    case let .threeValues3(value0, value1, value2):
                        String(format: localized("three_values3"), value0, value1, value2)
                    case let .fourValues(value0, value1, value2, value3):
                        String(format: localized("four_values"), value0, value1, value2, value3)
                    case let .fourValues2(value0, value1, value2, value3):
                        String(format: localized("four_values2"), value0, value1, value2, value3)
                    case let .fourValues3(value0, value1, value2, value3):
                        String(format: localized("four_values3"), value0, value1, value2, value3)
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testLowerSnakeCaseCasesWithNumbers() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .lowerSnakeCase)
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            }
            """,
            expandedSource:
            """
            enum Localization {
                case a
                case a1
                case a2345
                case ab8th9
                case c0cDdd4d
                case ABC6
            
                public var localized: String {
                    switch self {
                    case .a:
                        localized("a")
                    case .a1:
                        localized("a1")
                    case .a2345:
                        localized("a2345")
                    case .ab8th9:
                        localized("ab8th9")
                    case .c0cDdd4d:
                        localized("c0c_ddd4d")
                    case .ABC6:
                        localized("a_b_c6")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }

    func testLowerSnakeCaseWithBackticks() {
        #if canImport(LocalizationMacros)
        assertMacroExpansion(
            """
            @Localizable(keyFormat: .lowerSnakeCase)
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            }
            """,
            expandedSource:
            """
            enum Localization {
                case `case`
                case `continue`
                case `if`
                case `is`
                case `for`(stringValue: String)
                case `while`
            
                public var localized: String {
                    switch self {
                    case .`case`:
                        localized("case")
                    case .`continue`:
                        localized("continue")
                    case .`if`:
                        localized("if")
                    case .`is`:
                        localized("is")
                    case let .`for`(value0):
                        String(format: localized("for"), value0)
                    case .`while`:
                        localized("while")
                    }
                }
            
                private func localized(_ string: String) -> String {
                    NSLocalizedString(string, comment: "")
                }
            }
            """,
            macros: testMacros
        )
        #endif
    }
}
