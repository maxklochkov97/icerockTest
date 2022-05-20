//
//  DetailViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 20.05.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!

    var currentRepo: Repo?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLinkLabel()
    }

    private func setupLinkLabel() {
        guard let sentence = linkLabel.text else { return }
        let startIndex = sentence.index(sentence.startIndex, offsetBy: 8)
        linkLabel.text = String(sentence[startIndex...])

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tap)
    }

    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        guard let link = linkLabel.text, let url = URL(string: "https://" + link) else { return }
        UIApplication.shared.open(url)
    }

    func setupView() {
        self.navigationItem.title = currentRepo?.name
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .colorFive
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        self.linkLabel.text = currentRepo?.htmlUrl
        self.licenseLabel.text = currentRepo?.license?["key"]
        self.starsCountLabel.text = String(currentRepo?.stars ?? 0)
        self.forksCountLabel.text = String(currentRepo?.forks ?? 0)
        self.watchersCountLabel.text = String(currentRepo?.watchers ?? 0)
    }
}
