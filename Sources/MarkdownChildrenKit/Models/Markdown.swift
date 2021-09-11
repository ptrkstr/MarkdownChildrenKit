import Foundation

/// Represents a file with a .md extension
public struct Markdown: Equatable {
    
    /// The content of the first H1 (`#`) in the markdown, i.e. "This is a title".
    /// `nil` if no H1 was found.
    let firstH1: String?
    let url: URL
    private(set) var string: String
    
    init(url: URL) throws {
        do {
            let string = try String(contentsOf: url)
            var firstH1: String?
        
            string.enumerateLines { line, stop in
                if line.hasPrefix("# ") {
                    firstH1 = String(line.dropFirst(2))
                    stop = true
                }
            }
            
            self.firstH1 = firstH1
            self.url = url
            self.string = string
        } catch {
            throw MarkdownChildrenError.unableToReadMarkdownFile(.init(url: url))
        }
    }
    
    mutating func replace(from: String, to: String, with: String) throws {
        guard let start = string.endIndex(of: from) else {
            throw MarkdownChildrenError.missingTagInMarkdown(tag: from, .init(url: url))
        }
        
        guard let end = string.index(of: to) else {
            throw MarkdownChildrenError.missingTagInMarkdown(tag: to, .init(url: url))
        }
        
        string.replaceSubrange(start..<end, with: "\n\(with)\n")
    }
}
