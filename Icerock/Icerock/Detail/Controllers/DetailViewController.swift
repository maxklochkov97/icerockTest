//
//  DetailViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 20.05.2022.
//

import UIKit
import Down
import MaterialComponents.MaterialActivityIndicator

class DetailViewController: UIViewController {

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
    @IBOutlet weak var somethingErrorDetailView: SomethingErrorDetailView!
    @IBOutlet weak var mainActivityIndicator: MDCActivityIndicator!
    @IBOutlet weak var secondActivityIndicator: MDCActivityIndicator!
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
        setupView()
        setupActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        hiddenView()
        loadData()
    }

    private func setupView() {
        detailConnectionErrorView.updateDetailDelegate = self
        readmeLoadErrorView.updateDetailDelegate = self
    }

    private func setupActivityIndicator() {
        mainActivityIndicator.cycleColors = [.white]
        mainActivityIndicator.radius = 28
        mainActivityIndicator.strokeWidth = 7

        secondActivityIndicator.cycleColors = [.white]
        secondActivityIndicator.radius = 12
        secondActivityIndicator.strokeWidth = 3
    }

    func configure(with repo: Repo) {
        self.navigationItem.title = repo.name
        self.repoId = repo.id
    }

    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        appearance.backgroundColor = .background
        appearance.shadowImage = UIColor.navBarShadow.as1ptImage()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        let rightFilterButton = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(tabExitButton))
        rightFilterButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = rightFilterButton
    }

    @objc private func tabExitButton() {
        KeyValueStorage.authToken = nil

        guard let navigationController = self.navigationController else { return }

        let newVC = AuthViewController()
        navigationController.pushViewController(newVC, animated: true)

        var navigationArray = navigationController.viewControllers
        guard let temp = navigationArray.last else { return }
        navigationArray.removeAll()
        navigationArray.append(temp)
        self.navigationController?.viewControllers = navigationArray
    }

    @objc private func tabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupLinkLabel() {
        guard let sentence = linkLabel.text else { return }
        let startIndex = sentence.index(sentence.startIndex, offsetBy: 8)
        linkLabel.text = String(sentence[startIndex...])

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tap)
    }

    @objc private func onClicLabel(sender: UITapGestureRecognizer) {
        guard let link = linkLabel.text, let url = URL(string: "https://" + link) else { return }
        UIApplication.shared.open(url)
    }

    private func setupView(repo: RepoDetails) {
        self.linkLabel.text = repo.htmlUrl
        self.licenseLabel.text = repo.license?["key"] ?? NSLocalizedString("detailVC.licenseLabel.text", comment: "")
        self.starsCountLabel.text = String(repo.stars ?? 0)
        self.forksCountLabel.text = String(repo.forks ?? 0)
        self.watchersCountLabel.text = String(repo.watchers ?? 0)
        self.textLabel.numberOfLines = 0
    }

    private func getReadme(fullRepoName: String?) {
        guard let fullRepoName = fullRepoName else { return }
        self.scrollView.isHidden = false
        secondActivityIndicator.startAnimating()

        NetworkManager.getRepositoryReadme(fullRepoName: fullRepoName, completion: { [weak self] answer in
            switch answer {
            case .success(let dictionary):
                self?.secondActivityIndicator.stopAnimating()
                self?.text = dictionary
                self?.textLabel.textColor = .white

            case .failure(let error):
                self?.secondActivityIndicator.stopAnimating()
                switch error {
                case .noReadme:
                    self?.textLabel.text = "No README.md"
                default:
                    self?.scrollView.isHidden = true
                    self?.readmeLoadErrorView.isHidden = false
                }
                print("Error in \(#function) == \(error.localizedDescription)")
            }
        })
    }
}

extension DetailViewController: UpdateDetailDelegate {

    func hiddenView() {
        mainHeaderStack.isHidden = true
        scrollView.isHidden = true
        detailConnectionErrorView.isHidden = true
        readmeLoadErrorView.isHidden = true
        somethingErrorDetailView.isHidden = true
    }

    func loadData() {
        mainActivityIndicator.startAnimating()
        NetworkManager.getRepository(repoId: repoId) { [weak self] answer in
            switch answer {
            case .success(let repo):
                self?.setupView(repo: repo)
                self?.setupLinkLabel()
                self?.mainActivityIndicator.stopAnimating()
                self?.mainHeaderStack.isHidden = false
                self?.getReadme(fullRepoName: repo.fullName)
                
            case.failure(let error):
                self?.mainActivityIndicator.stopAnimating()
                switch error {
                case .noInternet:
                    self?.detailConnectionErrorView.isHidden = false
                default:
                    self?.somethingErrorDetailView.isHidden = false
                    print("Error in \(#function) == \(error.localizedDescription)")
                }
            }
        }
    }
}
