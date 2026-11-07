import XCTest

final class StudentDirectoryFlowUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func studentCellIdentifier(_ number: Int) -> String {
        "studentCell.\(String(format: "00000000-0000-0000-0000-%012d", number))"
    }

    private func studentCell(_ number: Int) -> XCUIElement {
        app.cells[studentCellIdentifier(number)]
    }

    private var detailsView: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "studentDetails").firstMatch
    }

    func testListShowsTitleTableAndStudents() {
        XCTAssertTrue(app.navigationBars["Students"].exists)
        XCTAssertTrue(app.tables["studentList"].exists)
        XCTAssertTrue(studentCell(1).exists)
        XCTAssertTrue(studentCell(2).exists)
    }

    func testTappingStudentOpensDetailsWithAllFields() {
        studentCell(1).tap()

        XCTAssertTrue(app.navigationBars["Ada Lovelace"].exists)
        XCTAssertTrue(detailsView.exists)
        XCTAssertTrue(app.staticTexts["ID: 00000000-0000-0000-0000-000000000001"].exists)
        XCTAssertTrue(app.staticTexts["Age: 20"].exists)
        XCTAssertTrue(app.staticTexts["Average grade: 97.5"].exists)
        XCTAssertTrue(app.staticTexts["Scholarship: Yes"].exists)
        XCTAssertTrue(app.staticTexts["Avatar: avatar-01"].exists)
        XCTAssertTrue(app.images["Ada Lovelace avatar"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Algorithms"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Math"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Design"].exists)
    }

    func testBackButtonReturnsToStudentList() {
        studentCell(1).tap()
        XCTAssertTrue(detailsView.exists)

        app.navigationBars.buttons["Students"].tap()

        XCTAssertTrue(app.tables["studentList"].exists)
        XCTAssertTrue(studentCell(2).exists)
    }

    func testSubjectButtonShowsOnlyMatchingStudents() {
        studentCell(1).tap()
        app.buttons["subjectButton.Math"].tap()

        // Math: Ada (1), Katherine (4), Donald (7)
        XCTAssertTrue(app.navigationBars["Math"].exists)
        XCTAssertTrue(studentCell(1).exists)
        XCTAssertTrue(studentCell(4).exists)
        XCTAssertTrue(studentCell(7).exists)
        XCTAssertFalse(studentCell(2).exists)
        XCTAssertFalse(studentCell(3).exists)

        let cells = app.tables["studentList"].cells
        XCTAssertEqual(cells.count, 3)
        XCTAssertEqual(
            cells.allElementsBoundByIndex.map(\.identifier),
            [studentCellIdentifier(1), studentCellIdentifier(4), studentCellIdentifier(7)]
        )
    }
}
