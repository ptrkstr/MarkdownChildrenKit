import Foundation

public struct List {
    
    /// Will always contain at least one ListItem
    let items: [ListItem]
    
    /// Must not be an empty directory
    public init(location: URL) throws {
        
        let manager = FileManager.default
        let directory = location.deletingLastPathComponent()
        
        var isDirectory: ObjCBool = false
        
        guard manager.fileExists(atPath: location.path, isDirectory: &isDirectory) else {
            throw MarkdownChildrenError.noFileExists(.init(url: location))
        }
        
        guard isDirectory.boolValue == false else {
            throw MarkdownChildrenError.directorySpecifiedInsteadOfFile(.init(url: location))
        }
        
        guard let enumerator = manager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles, .producesRelativePathURLs]
        ) else {
            throw MarkdownChildrenError.unableToSearchInDirectory(.init(url: directory))
        }
        
        items = try enumerator
            .compactMap {
                try ListItem(url: $0 as! URL)
            }
            .removingAll { $0.url.absoluteString == location.absoluteString }
            .sorted { $0.url.absoluteString.localizedStandardCompare($1.url.absoluteString) == .orderedAscending }
        
        guard items.isEmpty == false else {
            throw MarkdownChildrenError.directoryIsEmpty(.init(url: location))
        }
    }
}
