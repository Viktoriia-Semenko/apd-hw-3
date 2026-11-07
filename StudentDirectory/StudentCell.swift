import UIKit
import SnapKit

final class StudentCell: UITableViewCell {

    static let reuseIdentifier = "StudentCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        return label
    }()

    private let scholarshipLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(scholarshipLabel)

        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
        }

        detailsLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }

        scholarshipLabel.snp.makeConstraints {
            $0.top.equalTo(detailsLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName)
        nameLabel.text = student.name
        detailsLabel.text = "Age \(student.age) · Average grade \(String(format: "%.1f", student.averageGrade))"
        scholarshipLabel.text = student.isScholarshipHolder ? "Scholarship holder" : "No scholarship"

        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
    }
}
