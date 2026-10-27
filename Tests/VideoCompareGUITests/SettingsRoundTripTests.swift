import XCTest
@testable import VideoCompareGUI

final class SettingsRoundTripTests: XCTestCase {
    func testRoundTrip() throws {
        var s = Settings()
        s.highDPI = true
        s.windowSizeMode = "fixed"
        s.windowWidth = "1280"
        s.filtersBoth = "scale=2:2"
        let data = try JSONEncoder().encode(s)
        let decoded = try JSONDecoder().decode(Settings.self, from: data)
        XCTAssertEqual(decoded, s)
    }

    func testDefaultsDecode() throws {
        let s = Settings()
        let data = try JSONEncoder().encode(s)
        let decoded = try JSONDecoder().decode(Settings.self, from: data)
        XCTAssertEqual(decoded, s)
    }
}