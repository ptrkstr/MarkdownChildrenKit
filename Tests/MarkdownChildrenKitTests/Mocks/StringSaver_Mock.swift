import MarkdownChildrenKit
import Foundation

class StringSaver_Mock: StringSaverType {
    var save_mock: ((_ string: String, _ url: URL) -> ()) = { _, _ in }
    
    func save(_ string: String, to url: URL) throws {
        save_mock(string, url)
    }
}
