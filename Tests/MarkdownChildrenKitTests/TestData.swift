import Foundation

extension URL {
    static func testData(_ location: String) -> URL {
        Bundle.module.resourceURL!
            .appendingPathComponent("TestData\(location)")
    }
}
