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
        view.backgroundColor = .red
        //setupTableView()
    }

//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
}

//extension RepositoriesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if networkServiceError == nil {
//            return modelRepo.count
//        } else if networkServiceError == .isEmpty {
//            return 1
//        } else if networkServiceError == .noInternet {
//            return 1
//        } else if networkServiceError == .noData {
//            return 1
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if networkServiceError == nil {
//            return UITableViewCell()
//        } else if networkServiceError == .isEmpty {
//            return UITableViewCell()
//        } else {
//            return UITableViewCell()
//        }
//    }
//}
//
//extension RepositoriesListViewController: UITableViewDelegate {
//
//}
