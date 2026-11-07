import UIKit
import SnapKit

final class StudentListViewController: UIViewController {

    private let store: StudentStore

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.accessibilityIdentifier = "studentList"

        return tableView
    }()

    init(store: StudentStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Students"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension StudentListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseIdentifier, for: indexPath)

        if let studentCell = cell as? StudentCell {
            studentCell.configure(with: store.students[indexPath.row])
        }

        return cell
    }
}

extension StudentListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let student = store.students[indexPath.row]
        let detailViewController = StudentDetailViewController(student: student, store: store)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: StudentListViewController(store: StudentStore()))
}
