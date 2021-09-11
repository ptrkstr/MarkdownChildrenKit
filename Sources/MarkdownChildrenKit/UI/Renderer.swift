import Foundation

public struct Renderer {
    
    let list: List
    let nameType: ListItemMarkdownNameType
    
    public init(list: List, nameType: ListItemMarkdownNameType) {
        self.list = list
        self.nameType = nameType
    }
    
    public func render() throws -> String {
        
        var items = list.items
        let item = items.removeFirst()
        
        return try items.reduce(try render(item)) { output, item in
            let render = try self.render(item)
            return output.appending("\n" + render)
        }
    }
    
    private func render(_ item: ListItem) throws -> String {
        
        let url = item.url
        
        var output = ""
        
        var spacing = (0..<url.relativeStringDirectoryLevel)
            .reduce("") { result, _ in
                return result + "  "
            }
        
        spacing.append("- ")
        
        output.append(spacing)
        
        switch item {
        case .directory(let item):
            output.append(item.url.lastPathComponent)
        case .file(let item):
            let name = try self.name(for: item, given: nameType)
            output.append("[\(name)](\(url.relativeString))")
        }
        
        return output
    }
    
    private func name(for item: ListItemMarkdown, given type: ListItemMarkdownNameType) throws -> String {
        switch type {
        case .useH1:
            guard let heading = item.markdown.firstH1 else {
                throw MarkdownChildrenError.missingH1WhenExpected(.init(url: item.url))
            }
            return heading
        case .useH1withFilenameFallback:
            return item.markdown.firstH1 ?? item.filename
        case .useFilename:
            return item.filename
        }
    }
}
