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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: RepoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.identifier)
    }

    func configure(with array: [Repo]) {
        self.navigationItem.title = "Repositories"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .colorFive
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
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
            //cell.buttonAllPhotoDelegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = DetailViewController()
        // newView.configure(width: modelRepo[indexPath.row])
        newView.currentRepo = modelRepo[indexPath.row]
        navigationController?.pushViewController(newView, animated: true)
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
