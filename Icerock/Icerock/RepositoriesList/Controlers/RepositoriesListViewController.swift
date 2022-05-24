//
//  RepositoriesListViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 17.05.2022.
//

import UIKit

class RepositoriesListViewController: UIViewController {
    private var modelRepo: [Repo] = [Repo]()
    private var networkServiceError: NetworkServiceError? = nil
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var connectionErrorView: ConnectionErrorView!
    @IBOutlet weak var emptyView: EmptyView!
    @IBOutlet weak var somethingErrorView: SomethingErrorView!
    
    @IBOutlet weak var downloadImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionErrorView.updateReposDelegate = self
        emptyView.updateReposDelegate = self
        somethingErrorView.updateReposDelegate = self
        setupNavBar()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRepos()
    }
    
    private func stopAnimate() {
        downloadImage.layer.removeAllAnimations()
        downloadImage.isHidden = true
    }
    
    private func startAnimate() {
        downloadImage.rotate()
        downloadImage.isHidden = false
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: RepoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.identifier)
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .colorFive
        appearance.shadowImage = UIColor.colorEight.as1ptImage()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let rightFilterButton = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(tabBackButton))
        rightFilterButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightFilterButton
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.backButtonTitle = ""
        
        self.navigationItem.title = "Repositories"
    }
    
    @objc private func tabBackButton() {
        KeyValueStorage.userDefaults.removeObject(forKey: "token")
        self.navigationController?.popViewController(animated: true)
    }
    
    func configure(with array: [Repo]) {
        self.modelRepo = array
    }
    
}

extension RepositoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if networkServiceError == nil {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RepoTableViewCell.identifier,
                for: indexPath) as? RepoTableViewCell else {
                    return UITableViewCell()
                }
            cell.configure(width: modelRepo[indexPath.row])
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = DetailViewController()
        newView.configure(with: modelRepo[indexPath.row])
        navigationController?.pushViewController(newView, animated: true)
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RepositoriesListViewController: UpdateReposDelegate {
    func getRepos() {
        connectionErrorView.isHidden = true
        emptyView.isHidden = true
        somethingErrorView.isHidden = true
        tableView.isHidden = true
        startAnimate()

        NetworkManager.getRepositories { [weak self] answer in
            switch answer {
            case .success(let data):
                self?.modelRepo = data

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

                if data.isEmpty {
                    self?.emptyView.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                }
                self?.stopAnimate()
            case.failure(let error):
                self?.stopAnimate()
                switch error.localizedDescription {
                case "URLSessionTask failed with error: The Internet connection appears to be offline.":
                    self?.connectionErrorView.isHidden = false
                default:
                    self?.somethingErrorView.isHidden = false
                }
            }
        }
    }
}
