import Foundation

public struct MarkdownChildren {
    
    public init() {}
    
    public func process(_ configuration: Configuration) throws {
        let list = try List(location: configuration.url)
        let renderer = Renderer(list: list, nameType: configuration.nameType)
        let children = try renderer.render()
        var markdown = try Markdown(url: configuration.url)
        try markdown.replace(
            from: configuration.tagStart,
            to: configuration.tagEnd,
            with: children
        )
        try configuration.saver.save(markdown.string, to: configuration.url)
    }
}

