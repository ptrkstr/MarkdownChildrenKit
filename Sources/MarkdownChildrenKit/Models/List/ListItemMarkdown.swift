import Foundation

struct ListItemMarkdown {
    let url: URL
    let markdown: Markdown
    let filename: String
    
    /// Returns nil if not a markdown file
    init?(url: URL) throws {
        guard url.pathExtension.lowercased() == "md" else {
            return nil
        }
        self.url = url
        self.markdown = try .init(url: url)
        self.filename = url.lastPathComponent
    }
}
