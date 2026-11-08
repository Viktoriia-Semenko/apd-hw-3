import XCTest

final class StudentDirectoryBonusUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func studentCell(_ number: Int) -> XCUIElement {
        app.cells["studentCell.\(String(format: "00000000-0000-0000-0000-%012d", number))"]
    }

    private var nameField: XCUIElement { app.alerts.textFields["studentNameField"] }
    private var ageField: XCUIElement { app.alerts.textFields["studentAgeField"] }

    private func replaceText(in field: XCUIElement, with text: String) {
        field.tap()
        if let current = field.value as? String, !current.isEmpty {
            field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        }
        field.typeText(text)
    }

    func testAddingStudentShowsNewRowInList() {
        app.navigationBars.buttons["addStudentButton"].tap()

        nameField.tap()
        nameField.typeText("New Student")
        ageField.tap()
        ageField.typeText("19")
        app.alerts.buttons["Save"].tap()

        XCTAssertFalse(app.alerts.firstMatch.exists)
        XCTAssertTrue(app.tables["studentList"].staticTexts["New Student"].exists)
    }

    func testAddingStudentWithBlankNameShowsErrorAndAddsNothing() {
        app.navigationBars.buttons["addStudentButton"].tap()

        ageField.tap()
        ageField.typeText("19")
        app.alerts.buttons["Save"].tap()

        XCTAssertTrue(app.alerts["Error"].staticTexts["Name must not be blank."].exists)
        app.alerts["Error"].buttons["OK"].tap()

        XCTAssertFalse(app.tables["studentList"].staticTexts["New Student"].exists)
        XCTAssertTrue(studentCell(1).exists)
    }

    func testEditingStudentUpdatesDetailAndList() {
        studentCell(1).tap()
        app.navigationBars.buttons["editStudentButton"].tap()

        replaceText(in: nameField, with: "Ada Updated")
        replaceText(in: ageField, with: "30")
        app.alerts.buttons["Save"].tap()

        XCTAssertTrue(app.navigationBars["Ada Updated"].exists)
        XCTAssertTrue(app.staticTexts["Age: 30"].exists)

        app.navigationBars.buttons["Students"].tap()

        XCTAssertTrue(app.tables["studentList"].staticTexts["Ada Updated"].exists)
    }

    func testSwipeToDeleteRemovesStudentFromList() {
        studentCell(1).swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(studentCell(1).exists)
        XCTAssertTrue(studentCell(2).exists)
    }
}
