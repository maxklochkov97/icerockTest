//
//  Delegat.swift
//  Icerock
//
//  Created by Максим Клочков on 25.05.2022.
//

import Foundation

protocol UpdateReposDelegate: AnyObject {
    func hiddenView()
    func getRepos()
}
