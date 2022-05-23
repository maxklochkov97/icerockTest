//
//  RepoTableViewCell.swift
//  Icerock
//
//  Created by Максим Клочков on 17.05.2022.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(width repo: Repo) {
        self.headerLabel.text = repo.name
        self.languageLabel.text = repo.language
        self.descriptionLabel.text = repo.description
        self.descriptionLabel.numberOfLines = 3

        switch self.languageLabel.text {
        case "Swift":
            self.languageLabel.textColor = .colorSeven
        case "HTML":
            self.languageLabel.textColor = .green
        default:
            break
        }
    }
}
