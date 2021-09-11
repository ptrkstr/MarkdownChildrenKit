import XCTest
import Foundation
@testable import MarkdownChildrenKit

final class Markdown_Tests: XCTestCase {
    
    func test_single_h1() throws {
        // GIVEN single h1 exists in markdown
        let url = URL.testData("/markdowns/h1_single.md")
        
        // WHEN a `Markdown` is created
        let sut = try Markdown(url: url)

        // THEN the h1 is found
        XCTAssertEqual(sut.firstH1, "Title")
    }
    
    func test_multiple_h1() throws {
        // GIVEN multiple h1 exists in markdown
        let url = URL.testData("/markdowns/h1_multiple.md")
        
        // WHEN a `Markdown` is created
        let sut = try Markdown(url: url)
        
        // THEN the first h1 is found
        XCTAssertEqual(sut.firstH1, "Title")
    }
    
    func test_no_h1() throws {
        // GIVEN no h1 exists in markdown
        let url = URL.testData("/markdowns/h1_none.md")
        
        // WHEN a `Markdown` is created
        let sut = try Markdown(url: url)
        
        // THEN no h1 is found
        XCTAssertNil(sut.firstH1)
    }
}
