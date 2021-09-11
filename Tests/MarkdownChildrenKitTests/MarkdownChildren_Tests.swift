import XCTest
@testable import MarkdownChildrenKit

final class MarkdownChildren_Tests: XCTestCase {
    
    func test_noFileExists() {
        
        let sut = MarkdownChildren()
        
        // GIVEN a markdown file exists at the location
        let url = URL.testData("/noFileExist.md")
        // AND the directory is empty otherwise
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "",
                tagEnd: ""
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .noFileExists(.init(url: url)),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_directorySpecifiedInsteadOfFile() throws {
        
        // TODO: Figure out why this test fails on github actions
        try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] == "true")

        let sut = MarkdownChildren()

        // GIVEN a markdown file exists at the location
        let url = URL.testData("/directory/")
        // AND the directory is empty otherwise

        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "",
                tagEnd: ""
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .directorySpecifiedInsteadOfFile(.init(url: url)),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_directoryEmpty() {
        
        let sut = MarkdownChildren()
        
        // GIVEN a markdown file exists at the location
        let url = URL.testData("/directory_empty/readme.md")
        // AND the directory is empty otherwise
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "",
                tagEnd: ""
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .directoryIsEmpty(.init(url: url)),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_mdInvalid() {
        
        let sut = MarkdownChildren()
        
        // GIVEN an invalid markdown file exists in the location directory
        let url = URL.testData("/invalid_md/readme.md")
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "",
                tagEnd: ""
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .unableToReadMarkdownFile(.init(url: .testData("/invalid_md/invalid.md"))),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_nameTypeUseH1_mdMissingH1() {
        
        let sut = MarkdownChildren()
        
        // GIVEN an invalid markdown file exists in the location directory
        let url = URL.testData("/h1_missing/readme.md")
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useH1,
                tagStart: "",
                tagEnd: ""
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .missingH1WhenExpected(.init(url: .testData("/h1_missing/h1_missing.md"))),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_tagMissingStart() {
        
        let sut = MarkdownChildren()
        
        // GIVEN an invalid markdown file exists in the location directory
        let url = URL.testData("/tag_missing/tag_missing_start.md")
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "<!-- markdown-children:start -->",
                tagEnd: "<!-- markdown-children:end -->"
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .missingTagInMarkdown(tag: "<!-- markdown-children:start -->", .init(url: .testData("/h1_missing/h1_missing.md"))),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_tagMissingEnd() {
        
        let sut = MarkdownChildren()
        
        // GIVEN an invalid markdown file exists in the location directory
        let url = URL.testData("/tag_missing/tag_missing_end.md")
        
        // WHEN MarkdownChildren is invoked
        do {
            try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "<!-- markdown-children:start -->",
                tagEnd: "<!-- markdown-children:end -->"
            ))
        } catch {
            // THEN an exception is thrown
            XCTAssertEqual(
                .missingTagInMarkdown(tag: "<!-- markdown-children:end -->", .init(url: .testData("/h1_missing/h1_missing.md"))),
                error as! MarkdownChildrenError
            )
        }
    }
    
    func test_directoryComplex_nameTypeUseFilename() {

        let sut = MarkdownChildren()
        let saver = StringSaver_Mock()
        var actualString: String!
        var actualURL: URL!
        saver.save_mock = { string, url in
            actualString = string
            actualURL = url
        }

        // GIVEN a valid markdown file exists in the location directory
        let url = URL.testData("/directory_complex/readme.md")

        // WHEN MarkdownChildren is invoked
        XCTAssertNoThrow(try sut.process(.init(
                url: url,
                nameType: .useFilename,
                tagStart: "<!-- markdown-children:start -->",
                tagEnd: "<!-- markdown-children:end -->",
                saver: saver
            )))
        
        // THEN a valid list of children is saved
        XCTAssertEqual(
            "<!-- markdown-children:start -->\n- [animals.md](animals.md)\n- animals\n  - pets\n    - [cats.md](animals/pets/cats.md)\n    - [dogs.md](animals/pets/dogs.md)\n  - zoo\n    - [tiger.md](animals/zoo/tiger.md)\n- [clothes.md](clothes.md)\n- clothes\n  - summer\n    - [dress.md](clothes/summer/dress.md)\n    - [hat.md](clothes/summer/hat.md)\n  - winter\n    - [jumper.md](clothes/winter/jumper.md)\n    - [pants.md](clothes/winter/pants.md)\n<!-- markdown-children:end -->\n",
            actualString
        )
        XCTAssertEqual(
            url,
            actualURL
        )
    }
    
    func test_directoryComplex_nameTypeUseH1() {

        let sut = MarkdownChildren()
        let saver = StringSaver_Mock()
        var actualString: String!
        var actualURL: URL!
        saver.save_mock = { string, url in
            actualString = string
            actualURL = url
        }

        // GIVEN a valid markdown file exists in the location directory
        let url = URL.testData("/directory_complex/readme.md")

        // WHEN MarkdownChildren is invoked
        XCTAssertNoThrow(try sut.process(.init(
                url: url,
                nameType: .useH1,
                tagStart: "<!-- markdown-children:start -->",
                tagEnd: "<!-- markdown-children:end -->",
                saver: saver
            )))
        
        // THEN a valid list of children is saved
        XCTAssertEqual(
            "<!-- markdown-children:start -->\n- [Animals](animals.md)\n- animals\n  - pets\n    - [Cats](animals/pets/cats.md)\n    - [Dogs](animals/pets/dogs.md)\n  - zoo\n    - [Tiger](animals/zoo/tiger.md)\n- [Clothes](clothes.md)\n- clothes\n  - summer\n    - [Dress](clothes/summer/dress.md)\n    - [Hat](clothes/summer/hat.md)\n  - winter\n    - [Jumper](clothes/winter/jumper.md)\n    - [Pants](clothes/winter/pants.md)\n<!-- markdown-children:end -->\n",
            actualString
        )
        XCTAssertEqual(
            url,
            actualURL
        )
    }
    
    func test_directoryComplex_nameTypeUseH1withFilenameFallback() {

        let sut = MarkdownChildren()
        let saver = StringSaver_Mock()
        var actualString: String!
        var actualURL: URL!
        saver.save_mock = { string, url in
            actualString = string
            actualURL = url
        }

        // GIVEN a valid markdown file exists in the location directory
        let url = URL.testData("/directory_complex2/readme.md")

        // WHEN MarkdownChildren is invoked
        XCTAssertNoThrow(try sut.process(.init(
                url: url,
                nameType: .useH1withFilenameFallback,
                tagStart: "<!-- markdown-children:start -->",
                tagEnd: "<!-- markdown-children:end -->",
                saver: saver
            )))
        
        // THEN a valid list of children is saved
        XCTAssertEqual(
            "<!-- markdown-children:start -->\n- [Animals](animals.md)\n- animals\n  - pets\n    - [cats.md](animals/pets/cats.md)\n    - [Dogs](animals/pets/dogs.md)\n  - zoo\n    - [Tiger](animals/zoo/tiger.md)\n- [clothes.md](clothes.md)\n- clothes\n  - summer\n    - [Dress](clothes/summer/dress.md)\n    - [Hat](clothes/summer/hat.md)\n  - winter\n    - [jumper.md](clothes/winter/jumper.md)\n    - [pants.md](clothes/winter/pants.md)\n<!-- markdown-children:end -->\n",
            actualString
        )
        XCTAssertEqual(
            url,
            actualURL
        )
    }
}
