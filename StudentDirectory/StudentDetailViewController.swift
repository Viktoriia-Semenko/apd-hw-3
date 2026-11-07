import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {

    private let student: Student
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

        title = student.name
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentDetails"

        avatarImageView.image = UIImage(named: student.avatarName)
        avatarImageView.isAccessibilityElement = true
        avatarImageView.accessibilityLabel = "\(student.name) avatar"

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(makeLabel(student.name, style: .title2))
        stackView.addArrangedSubview(makeLabel("ID: \(student.id.uuidString)", style: .footnote))
        stackView.addArrangedSubview(makeLabel("Age: \(student.age)", style: .body))
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

        return button
    }
}

#Preview {
    UINavigationController(
        rootViewController: StudentDetailViewController(student: StudentSeedData.students[0], store: StudentStore())
    )
}
