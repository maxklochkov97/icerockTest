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

    @IBOutlet weak var secondaryDownload: UIImageView!
    @IBOutlet weak var mainDownload: UIImageView!
    @IBOutlet weak var mainHeaderStack: UIStackView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailConnectionErrorView: DetailConnectionErrorView!
    @IBOutlet weak var readmeLoadErrorView: ReadmeLoadErrorView!

    private var repoId = 0
    private var text: String = "" {
        didSet {
            let down = Down(markdownString: text)
            let attributedString = try? down.toAttributedString()
            self.textLabel.attributedText = attributedString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailConnectionErrorView.updateDetailDelegate = self
        readmeLoadErrorView.updateDetailDelegate = self
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenView()
        loadData()


    }

    private func stopAnimate(_ image: UIImageView) {
        image.layer.removeAllAnimations()
        image.isHidden = true
    }

    private func startAnimate(_ image: UIImageView) {
        image.rotate()
        image.isHidden = false
    }

    func configure(with repo: Repo) {
        self.navigationItem.title = repo.name
        self.repoId = repo.id
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

        let leftBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .done, target: self, action: #selector(tapUpdateAction) )
        leftBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBackButton
    }

    // MARK: - доработать. При выходе идет откат на прошлую страничку с вечной загрузкой.
    @objc private func tabExitButton() {
        KeyValueStorage.userDefaults.removeObject(forKey: "token")
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func tapUpdateAction() {
        hiddenView()
        loadData()
    }

    @objc private func tabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func downloadReadme(fullRepoName: String?, branchName: String?) {
        guard let fullRepoName = fullRepoName,
              let branchName = branchName else { return }
        startAnimate(secondaryDownload)

        NetworkManager.getRepositoryReadme(fullRepoName: fullRepoName, branchName: branchName, completion: { [weak self] answer in
            switch answer {
            case .success(let dictionary):
                self?.text = dictionary
                self?.textLabel.textColor = .white
                self?.stopAnimate((self?.secondaryDownload)!)
                self?.scrollView.isHidden = false
            case .failure(_):
                self?.stopAnimate((self?.secondaryDownload)!)
                if NetworkMonitor.shared.isConnected {
                    self?.scrollView.isHidden = false
                    self?.textLabel.text = "No README.md"
                } else {
                    self?.readmeLoadErrorView.isHidden = false
                }

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

    @objc private func onClicLabel(sender:UITapGestureRecognizer) {
        guard let link = linkLabel.text, let url = URL(string: "https://" + link) else { return }
        UIApplication.shared.open(url)
    }

    private func setupView(repo: RepoDetails) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .colorFive
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        self.linkLabel.text = repo.htmlUrl
        self.licenseLabel.text = repo.license?["key"]
        self.starsCountLabel.text = String(repo.stars ?? 0)
        self.forksCountLabel.text = String(repo.forks ?? 0)
        self.watchersCountLabel.text = String(repo.watchers ?? 0)
        self.textLabel.numberOfLines = 0
    }
}


extension DetailViewController: UpdateDetailDelegate {

    func hiddenView() {
        mainHeaderStack.isHidden = true
        scrollView.isHidden = true
        mainDownload.isHidden = true
        secondaryDownload.isHidden = true
        detailConnectionErrorView.isHidden = true
        readmeLoadErrorView.isHidden = true
    }

    func loadData() {

        startAnimate(mainDownload)
        NetworkManager.getRepository(repoId: repoId) { [weak self] answer in
            switch answer {
            case .success(let repo):
                self?.setupView(repo: repo)
                self?.setupLinkLabel()
                self?.stopAnimate((self?.mainDownload)!)
                self?.mainHeaderStack.isHidden = false
                self?.downloadReadme(fullRepoName: repo.fullName , branchName: repo.defaultBranch)
            case.failure(let error):
                self?.stopAnimate((self?.mainDownload)!)

                switch error.localizedDescription {
                case "URLSessionTask failed with error: The Internet connection appears to be offline.":
                    self?.detailConnectionErrorView.isHidden = false
                default:
                    break
                }
                print(error.localizedDescription)
            }
        }
    }
}
