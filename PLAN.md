# HW3 Student Plan

## Approach

I will build the Student Directory app using UIKit, MVC, and SnapKit.

- **Model:** use the existing `Student` structure, `StudentSeedData`, and `StudentStore`. I will keep the supplied student data unchanged.
- **View:** use UIKit components such as `UITableView`, `UILabel`, `UIImageView`, and `UIButton`. SnapKit will be used for layout constraints.
- **Controller:** use view controllers to manage the student list, student details, user interactions, and navigation.

One shared `StudentStore` instance will be passed between screens so the app uses the same data source.

The main screen will show all students in a table view. Selecting a student will open a detail screen with all their information. Selecting a subject will open another list showing only students enrolled in that subject.

Subject filtering will use the existing `students(matchingSubject:)` method. It will preserve the original student order and use exact, case-sensitive matching.

For accessibility, I will add the required identifiers, meaningful labels, and Dynamic Type-compatible text.

## Milestones

- [x] Build the student list using `UITableView` and a reusable custom cell.
- [x] Display each student's avatar, name, age, average grade, and scholarship status.
- [x] Create a student detail screen and navigation using `UINavigationController`.
- [x] Implement subject filtering and the filtered student list.
- [x] Add accessibility identifiers and support Dynamic Type.
- [x] Add at least six meaningful XCTest methods covering model/store logic and UI behaviour.
- [x] Consider the optional add/edit/delete functionality after the base requirements are complete.
- [x] Run local verification and review GitHub Actions results.
- [x] Review the final Git diff, documentation, and evidence before submission.
- [x] Complete AGENT_WORKLOG.md with AI tool usage, reviewed recommendations, local test results, and GitHub Actions evidence.
- [x] Complete optional add/edit/delete functionality.

## Verification Plan

I will test the following:

1. The student list displays the supplied students correctly.
2. Selecting a student opens the correct detail screen.
3. The detail screen displays all student fields.
4. Subject filtering returns only matching students in the original order.
5. Subject filtering is exact and case-sensitive.
6. Accessibility identifiers can be used to locate important UI elements.

I will keep the existing starter tests unchanged and add at least six new meaningful XCTest methods.

The final verification command will be:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Then confirm the GitHub Actions run for the pushed commit is green.

## Scope

My first priority is to complete all 12 base points with a simple and maintainable implementation. The optional bonus will be considered afterwards.