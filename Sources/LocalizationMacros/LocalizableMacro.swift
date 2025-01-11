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
        
        let localizedVar = try localizedVariableDecl(with: elements)
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
    
    private static func localizedVariableDecl(with elements: [EnumCaseElementListSyntax.Element]) throws -> VariableDeclSyntax {
        try VariableDeclSyntax("public var localized: String") {
            try SwitchExprSyntax("switch self") {
                for element in elements {
                    caseSyntax(for: element)
                }
            }
        }
    }
    
    private static func caseSyntax(for element: EnumCaseElementSyntax) -> SwitchCaseSyntax {
        if element.parameterClause != nil {
            return formatLocalized(from: element)
        }
        return localize(element)
    }

    private static func localize(_ element: EnumCaseElementSyntax) -> SwitchCaseSyntax {
        SwitchCaseSyntax(
        """
        case .\(element.name):
            localized("\(raw: "\(element.name.toLocalizedKey)")")
        """
        )
    }
    
    private static func formatLocalized(from element: EnumCaseElementSyntax) -> SwitchCaseSyntax {
        let parameterList = element.parameterClause?.parameters ?? []
        return SwitchCaseSyntax(
        """
        case let .\(element.name)(\(raw: formatArguments(from: parameterList))):
            String(format: localized("\(raw: "\(element.name.toLocalizedKey)")"),\(raw: formatArguments(from: parameterList)))
        """
        )
    }
    
    private static func formatArguments(from list: EnumCaseParameterListSyntax) -> String {
        list
            .enumerated()
            .map { ($0.offset == 0 ? "" : " ") + "value\($0.offset)" }
            .joined(separator: ",")
    }
}

@main
struct LocalizedPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LocalizableMacro.self,
    ]
}

fileprivate extension String {
    var snakeCased: String {
        let pattern = "(?<=\\w)(?=[A-Z])|(?<=[A-Z])(?=[A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: .zero, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1$3_$2$4").uppercased() ?? self
    }
    
    var backticksRemoved: String {
        replacingOccurrences(of: "`", with: "")
    }
}

fileprivate extension TokenSyntax {
    
    var toLocalizedKey: String {
        "\(self)".snakeCased.backticksRemoved
    }
}
