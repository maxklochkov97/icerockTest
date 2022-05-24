//
//  DetailViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 20.05.2022.
//

import UIKit
import Down

// Сделать загрузку данных при инициализации, а то не свежие данные

class DetailViewController: UIViewController {

    var savedToken: String?

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!

    var currentRepo: Repo?
    var index = 0
    private var text: String = "" {
        didSet {
            let down = Down(markdownString: text)
            let attributedString = try? down.toAttributedString()
            self.textLabel.attributedText = attributedString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        loadData()
        setupLinkLabel()
        downloadReadme()
    }

    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .colorFive
        appearance.shadowImage = UIColor.colorEight.as1ptImage()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        let rightFilterButton = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(tabExitButton))
        rightFilterButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightFilterButton
    }

    @objc private func tabExitButton() {
        //UserDefaults.standard.removeObject(forKey: "token")
        NetworkManager.userDefaults.removeObject(forKey: "token")
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func tabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func downloadReadme() {
        guard let fullRepoName = currentRepo?.fullName,
              let branchName = currentRepo?.defaultBranch else { return }

        NetworkManager.getRepositoryReadme(fullRepoName: fullRepoName, branchName: branchName, completion: { path, error in
            guard let path = path else { return }
            do {
                let dictionary = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                self.text = dictionary
                self.textLabel.textColor = .white
            } catch {
                print("Error = \(error.localizedDescription)")
            }
        })
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

    private func setupView() {
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
        
        self.textLabel.text = NetworkManager.text
        self.textLabel.numberOfLines = 0
    }

    private func loadData() {

        guard let savedToken = savedToken else  {return }

        NetworkManager.getRepositories(token: savedToken) { [weak self] answer in
            switch answer {
            case .success(let data):
                var index2 = 0
                //print(data)
                if let repo = data.firstIndex(where: { $0.id == self?.index }) {
                    index2 = repo
                    //print(repo)
                }
                self?.currentRepo = data[index2]
                self?.setupView()
                self?.setupLinkLabel()
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
