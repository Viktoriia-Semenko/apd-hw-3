import UIKit

enum StudentFormAlert {

    static func make(
        title: String,
        name: String,
        age: String,
        save: @escaping (_ name: String, _ age: Int) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.text = name
            textField.accessibilityIdentifier = "studentNameField"
        }

        alert.addTextField { textField in
            textField.placeholder = "Age"
            textField.text = age
            textField.keyboardType = .numberPad
            textField.accessibilityIdentifier = "studentAgeField"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            let nameText = alert?.textFields?[0].text ?? ""
            let ageText = alert?.textFields?[1].text ?? ""
            let ageValue = Int(ageText.trimmingCharacters(in: .whitespaces)) ?? 0
            save(nameText, ageValue)
        })

        return alert
    }

    static func makeError(_ error: Error) -> UIAlertController {
        let message = (error as? StudentStoreError)?.message ?? error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        return alert
    }
}

extension StudentStoreError {
    var message: String {
        switch self {
        case .blankName:
            return "Name must not be blank."
        case .nonPositiveAge:
            return "Age must be greater than 0."
        case .unknownID:
            return "Student not found."
        }
    }
}
