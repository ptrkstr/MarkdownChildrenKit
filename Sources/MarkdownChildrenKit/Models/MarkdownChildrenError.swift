import Foundation

/// URLs equat differently depending on whether they're relative
/// or absolute even if they have the same absolutePath.
/// We want to make use of enum associated value equality checking
/// so will use our own URL type.
public struct EquatableURL: Equatable, CustomStringConvertible {
    public let url: URL
    
    public var description: String {
        url.absoluteString
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.url.absoluteString == lhs.url.absoluteString
    }
}

enum MarkdownChildrenError: Error, CustomStringConvertible, Equatable {
    case unableToSearchInDirectory(EquatableURL)
    case unableToReadMarkdownFile(EquatableURL)
    case directoryIsEmpty(EquatableURL)
    case missingH1WhenExpected(EquatableURL)
    case missingTagInMarkdown(tag: String, EquatableURL)
    case noFileExists(EquatableURL)
    case directorySpecifiedInsteadOfFile(EquatableURL)
    
    var description: String {
        switch self {
        case .unableToSearchInDirectory(let url): return "Unable to search in `\(url)`.\nIt's unknown what causes this."
        case .unableToReadMarkdownFile(let url): return "Unable to read `\(url)`.\nCheck if file is valid."
        case .directoryIsEmpty(let url): return "An empty directory containing the following was provided: `\(url)`.\nEnsure there is at least a directory or markdown file that's able to be processed. This excludes the provided `\(url)`"
        case .missingH1WhenExpected(let url): return "Expecting to find `# ` heading in file `\(url)`.\nCheck `# ` exists in the file, or change the name type used."
        case .missingTagInMarkdown(let tag, let url): return "Didn't find `\(tag)` in `\(url).`\nEnsure \(tag) exists."
        case .noFileExists(let url): return "No file exists at `\(url)`.\nCheck the path provided."
        case .directorySpecifiedInsteadOfFile(let url): return "Directory specified instead of file at `\(url).\nCheck the path provided."
        }
    }
    
    
}
