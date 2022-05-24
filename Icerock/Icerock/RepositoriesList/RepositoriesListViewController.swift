//
//  RepositoriesListViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 17.05.2022.
//

import UIKit

class RepositoriesListViewController: UIViewController {
    var savedToken: String?

    private var modelRepo: [Repo] = [Repo]()
    private var networkServiceError: NetworkServiceError? = nil
    private let reachability = try! Reachability()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }

    deinit {
        reachability.stopNotifier()
    }

    private func networkErrors() {
        DispatchQueue.main.async {
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
            }
            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
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
        //UserDefaults.standard.removeObject(forKey: "token")
        NetworkManager.userDefaults.removeObject(forKey: "token")
        self.navigationController?.popViewController(animated: true)
    }

    func configure(with array: [Repo]) {
        self.modelRepo = array
    }
    
}

extension RepositoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if networkServiceError == nil {
            return modelRepo.count
        } else if networkServiceError == .isEmpty {
            return 1
        } else if networkServiceError == .noInternet {
            return 1
        } else if networkServiceError == .noData {
            return 1
        } else {
            return 0
        }
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
        newView.currentRepo = modelRepo[indexPath.row]
        newView.index = modelRepo[indexPath.row].id
        newView.savedToken = self.savedToken
        navigationController?.pushViewController(newView, animated: true)
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
