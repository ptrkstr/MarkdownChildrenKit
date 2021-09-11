import Foundation

public protocol StringSaverType {
    func save(_ string: String, to url: URL) throws
}

public class StringSaver: StringSaverType {
    
    public init() {}
    
    public func save(_ string: String, to url: URL) throws {
        try string.write(to: url, atomically: true, encoding: .utf8)
    }
}
