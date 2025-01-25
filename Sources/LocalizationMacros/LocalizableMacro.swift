import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct LocalizableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(.notAnEnum, with: declaration)
            return []
        }
        
        let members = enumDecl.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap { $0.elements }
        let keyFormat = extractArgument(.keyFormat, outOf: node)
        
        let localizedVar = try localizedVariableDecl(with: elements, keyFormat)
        let localizeFuncDecl = try localizeFuncionDecl()
        
        return [
            DeclSyntax(localizedVar),
            DeclSyntax(localizeFuncDecl)
        ]
    }
    
    /// This localized function is used instead of explicit initializer, so it can be modified in the future if needed
    private static func localizeFuncionDecl() throws -> FunctionDeclSyntax {
        try FunctionDeclSyntax("private func localized(_ string: String) -> String") {
            """
            NSLocalizedString(string, comment: "")
            """
        }
    }
    
    private static func localizedVariableDecl(with elements: [EnumCaseElementListSyntax.Element], _ keyFormat: String?) throws -> VariableDeclSyntax {
        try VariableDeclSyntax("public var localized: String") {
            try SwitchExprSyntax("switch self") {
                for element in elements {
                    caseSyntax(for: element, using: keyFormat)
                }
            }
        }
    }
    
    private static func caseSyntax(for element: EnumCaseElementSyntax, using keyFormat: String?) -> SwitchCaseSyntax {
        if let parameterList = element.parameterClause?.parameters {
            return SwitchCaseSyntax(
            """
            case let .\(element.name)(\(raw: formatArguments(from: parameterList))):
                String(format: localized("\(raw: "\(element.name.toLocalizedKey(using: keyFormat))")"),\(raw: formatArguments(from: parameterList)))
            """
            )
        }
        
        return SwitchCaseSyntax(
        """
        case .\(element.name):
            localized("\(raw: "\(element.name.toLocalizedKey(using: keyFormat))")")
        """
        )
    }
    
    private static func formatArguments(from list: EnumCaseParameterListSyntax) -> String {
        list
            .enumerated()
            .map { ($0.offset == 0 ? "" : " ") + "value\($0.offset)" }
            .joined(separator: ",")
    }
    
    private static func extractArgument(_ argumentType: ArgumentType, outOf node: AttributeSyntax) -> String? {
        guard case let .argumentList(arguments) = node.arguments,
              let argument = arguments.first(where: { $0.label?.text == argumentType.rawValue }) else { return nil }
        
        return switch argumentType {
        case .keyFormat:
            argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
        }
    }
}

@main
struct LocalizablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LocalizableMacro.self,
    ]
}

fileprivate enum ArgumentType: String {
    case keyFormat
}

fileprivate extension TokenSyntax {
    
    func toLocalizedKey(using keyFormat: String?) -> String {
        switch keyFormat {
        case "lowerSnakeCase":
            "\(self)".snakeCased.lowercased().removingBackticks
        case "upperSnakeCase":
            "\(self)".snakeCased.uppercased().removingBackticks
        default:
            "\(self)".removingBackticks
        }
    }
}

fileprivate extension String {
    var snakeCased: String {
        let pattern = "(?<=\\w)(?=[A-Z])|(?<=[A-Z])(?=[A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: .zero, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1$3_$2$4") ?? self
    }
    
    var removingBackticks: String {
        replacingOccurrences(of: "`", with: "")
    }
}
