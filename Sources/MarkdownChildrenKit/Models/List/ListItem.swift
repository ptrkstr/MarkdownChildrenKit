import Foundation

enum ListItem {
    case file(ListItemMarkdown)
    case directory(ListItemDirectory)
    
    var url: URL {
        switch self {
        case .file(let file): return file.url
        case .directory(let directory): return directory.url
        }
    }
    
    init?(url: URL) throws {
        if url.hasDirectoryPath {
            self = .directory(ListItemDirectory(url: url))
        } else {
            if let markdown = try ListItemMarkdown(url: url) {
                self = .file(markdown)
            } else {
                return nil
            }
        }
    }
}
