import XCTest
@testable import VideoCompareGUI

final class VideoCompareLocatorTests: XCTestCase {
    func testWellKnownFirst() {
        let url = VideoCompareLocator.locate(candidates: ["/a/video-compare", "/b/video-compare"], pathEnv: nil) { $0 == "/a/video-compare" }
        XCTAssertEqual(url?.path, "/a/video-compare")
    }

    func testPathFallback() {
        let url = VideoCompareLocator.locate(candidates: ["/nope"], pathEnv: "/x:/y") { $0 == "/y/video-compare" }
        XCTAssertEqual(url?.path, "/y/video-compare")
    }

    func testNotFound() {
        let url = VideoCompareLocator.locate(candidates: [], pathEnv: "/x") { _ in false }
        XCTAssertNil(url)
    }
}