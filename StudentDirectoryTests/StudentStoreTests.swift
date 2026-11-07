import XCTest
import UIKit
@testable import StudentDirectory

final class StudentStoreTests: XCTestCase {

    // MARK: - Subject filtering

    func testSubjectFilterReturnsMatchingStudentsInStoreOrder() {
        let store = StudentStore()

        let names = store.students(matchingSubject: "Math").map(\.name)

        XCTAssertEqual(names, ["Ada Lovelace", "Katherine Johnson", "Donald Knuth"])
    }

    func testSubjectFilterIsCaseSensitiveAndUnknownSubjectIsEmpty() {
        let store = StudentStore()

        XCTAssertTrue(store.students(matchingSubject: "math").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "Chemistry").isEmpty)
    }

    // MARK: - Add

    func testAddStudentUsesDefaultValues() throws {
        let store = StudentStore()

        try store.addStudent(name: "New Student", age: 19)

        XCTAssertEqual(store.students.count, 11)
        let added = try XCTUnwrap(store.students.last)
        XCTAssertEqual(added.name, "New Student")
        XCTAssertEqual(added.age, 19)
        XCTAssertEqual(added.averageGrade, 0)
        XCTAssertFalse(added.isScholarshipHolder)
        XCTAssertTrue(added.subjects.isEmpty)
        XCTAssertEqual(added.avatarName, "avatar-default")
        XCTAssertFalse(StudentSeedData.students.contains { $0.id == added.id })
    }

    func testAddStudentRejectsBlankNameAndNonPositiveAge() {
        let store = StudentStore()

        XCTAssertThrowsError(try store.addStudent(name: "   ", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid Name", age: 0)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid Name", age: -5)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }

        XCTAssertEqual(store.students, StudentSeedData.students)
    }

    // MARK: - Update

    func testUpdateStudentChangesOnlyNameAndAge() throws {
        let store = StudentStore()
        let original = StudentSeedData.students[0]

        try store.updateStudent(id: original.id, name: "Ada Updated", age: 30)

        let updated = try XCTUnwrap(store.students.first { $0.id == original.id })
        XCTAssertEqual(updated.name, "Ada Updated")
        XCTAssertEqual(updated.age, 30)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
        XCTAssertEqual(store.students.count, 10)
    }

    func testInvalidUpdateAndUnknownIDsDoNotChangeStore() {
        let store = StudentStore()
        let existingID = StudentSeedData.students[0].id
        let unknownID = UUID()

        XCTAssertThrowsError(try store.updateStudent(id: existingID, name: "", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.updateStudent(id: existingID, name: "Name", age: 0)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.updateStudent(id: unknownID, name: "Name", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }
        XCTAssertThrowsError(try store.deleteStudent(id: unknownID)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }

        XCTAssertEqual(store.students, StudentSeedData.students)
    }

    // MARK: - Avatar assets

    func testSeedStudentAvatarsCanBeLoaded() {
        let appBundle = Bundle(for: StudentStore.self)

        for student in StudentSeedData.students {
            XCTAssertNotNil(
                UIImage(named: student.avatarName, in: appBundle, compatibleWith: nil),
                "Missing avatar asset for \(student.name): \(student.avatarName)"
            )
        }
    }

    // MARK: - Delete

    func testDeleteStudentRemovesOnlyThatStudent() throws {
        let store = StudentStore()
        let removed = StudentSeedData.students[1]

        try store.deleteStudent(id: removed.id)

        let expected = StudentSeedData.students.filter { $0.id != removed.id }
        XCTAssertEqual(store.students.count, 9)
        XCTAssertFalse(store.students.contains { $0.id == removed.id })
        XCTAssertEqual(store.students, expected)
    }
}
