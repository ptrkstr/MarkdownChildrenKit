import Foundation

public struct Configuration {
    
    public let url: URL
    public let nameType: ListItemMarkdownNameType
    public let tagStart: String
    public let tagEnd: String
    public let saver: StringSaverType
    
    public init(url: URL, nameType: ListItemMarkdownNameType, tagStart: String, tagEnd: String, saver: StringSaverType = StringSaver()) {
        self.url = url
        self.nameType = nameType
        self.tagStart = tagStart
        self.tagEnd = tagEnd
        self.saver = saver
    }
}
