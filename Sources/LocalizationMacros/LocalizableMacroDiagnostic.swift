import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

enum LocalizableMacroDiagnostic {
    case notAnEnum
}

extension LocalizableMacroDiagnostic: DiagnosticMessage {
    var severity: DiagnosticSeverity { .error }

    var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "Localization.\(self)")
    }

    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    var message: String {
        switch self {
        case .notAnEnum:
            return "'Localized' macro can only be attached to enums"
        }
    }
}

extension MacroExpansionContext {
    func diagnose(_ diagnostic: LocalizableMacroDiagnostic, with declaration: some DeclGroupSyntax) {
        diagnose(diagnostic.diagnose(at: declaration))
    }
}
