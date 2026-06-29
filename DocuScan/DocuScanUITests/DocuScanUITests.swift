import XCTest

final class DocuScanUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "-hasCompletedOnboarding", "true"]
        app.launch()
    }

    func testTabBarExists() throws {
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }

    func testToolsTabIsDefault() throws {
        let toolsTab = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(toolsTab.isSelected)
    }

    func testNavigateToRecent() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        // Verify at least 2 tabs exist (Recent is at index 1)
        XCTAssertGreaterThan(tabBar.buttons.count, 1)
    }

    func testNavigateToSettings() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        // Verify at least 4 tabs exist (Settings is at index 3)
        XCTAssertGreaterThan(tabBar.buttons.count, 3)
    }
}
