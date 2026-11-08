import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {

    private var student: Student
    private let store: StudentStore

    private let scrollView = UIScrollView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12

        return stackView
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50

        return imageView
    }()

    private lazy var nameLabel = makeLabel("", style: .title2)
    private lazy var ageLabel = makeLabel("", style: .body)

    init(student: Student, store: StudentStore) {
        self.student = student
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentDetails"

        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        editButton.accessibilityIdentifier = "editStudentButton"
        navigationItem.rightBarButtonItem = editButton

        avatarImageView.isAccessibilityElement = true

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(makeLabel("ID: \(student.id.uuidString)", style: .footnote))
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(makeLabel("Average grade: \(String(format: "%.1f", student.averageGrade))", style: .body))
        stackView.addArrangedSubview(makeLabel("Scholarship: \(student.isScholarshipHolder ? "Yes" : "No")", style: .body))
        stackView.addArrangedSubview(makeLabel("Avatar: \(student.avatarName)", style: .body))
        stackView.addArrangedSubview(makeLabel("Subjects:", style: .headline))

        if student.subjects.isEmpty {
            stackView.addArrangedSubview(makeLabel("None", style: .body))
        }

        for subject in student.subjects {
            let button = makeSubjectButton(subject)
            stackView.addArrangedSubview(button)

            button.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(44)
            }
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(16)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-32)
        }

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }

        showStudent()
    }

    private func showStudent() {
        title = student.name
        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age)"
        avatarImageView.image = UIImage(named: student.avatarName)
        avatarImageView.accessibilityLabel = "\(student.name) avatar"
    }

    @objc private func editTapped() {
        let alert = StudentFormAlert.make(
            title: "Edit Student",
            name: student.name,
            age: String(student.age)
        ) { [weak self] name, age in
            self?.saveChanges(name: name, age: age)
        }
        present(alert, animated: true)
    }

    private func saveChanges(name: String, age: Int) {
        do {
            try store.updateStudent(id: student.id, name: name, age: age)
        } catch {
            present(StudentFormAlert.makeError(error), animated: true)
            return
        }

        if let updated = store.students.first(where: { $0.id == student.id }) {
            student = updated
            showStudent()
        }
    }

    private func makeLabel(_ text: String, style: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }

    private func makeSubjectButton(_ subject: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(subject, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.accessibilityIdentifier = "subjectButton.\(subject)"

        button.addAction(UIAction { [weak self] _ in
            self?.showStudents(matching: subject)
        }, for: .touchUpInside)

        return button
    }

    private func showStudents(matching subject: String) {
        let listViewController = StudentListViewController(store: store, subject: subject)
        navigationController?.pushViewController(listViewController, animated: true)
    }
}

#Preview {
    UINavigationController(
        rootViewController: StudentDetailViewController(student: StudentSeedData.students[0], store: StudentStore())
    )
}
