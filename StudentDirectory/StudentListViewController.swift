import UIKit
import SnapKit

final class StudentListViewController: UIViewController {

    private let store: StudentStore
    private let subject: String?

    private var students: [Student] {
        if let subject = subject {
            return store.students(matchingSubject: subject)
        }
        return store.students
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.accessibilityIdentifier = "studentList"

        return tableView
    }()

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = subject ?? "Students"
        view.backgroundColor = .systemBackground

        if subject == nil {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            addButton.accessibilityIdentifier = "addStudentButton"
            addButton.accessibilityLabel = "Add student"
            navigationItem.rightBarButtonItem = addButton
        }

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @objc private func addTapped() {
        let alert = StudentFormAlert.make(title: "Add Student", name: "", age: "") { [weak self] name, age in
            self?.addStudent(name: name, age: age)
        }
        present(alert, animated: true)
    }

    private func addStudent(name: String, age: Int) {
        do {
            try store.addStudent(name: name, age: age)
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: students.count - 1, section: 0), at: .bottom, animated: true)
        } catch {
            present(StudentFormAlert.makeError(error), animated: true)
        }
    }
}

extension StudentListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseIdentifier, for: indexPath)

        if let studentCell = cell as? StudentCell {
            studentCell.configure(with: students[indexPath.row])
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let student = students[indexPath.row]

        do {
            try store.deleteStudent(id: student.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            present(StudentFormAlert.makeError(error), animated: true)
        }
    }
}

extension StudentListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let student = students[indexPath.row]
        let detailViewController = StudentDetailViewController(student: student, store: store)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: StudentListViewController(store: StudentStore()))
}
