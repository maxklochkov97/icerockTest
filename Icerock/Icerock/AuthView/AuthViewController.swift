//
//  LoginViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 13.05.2022.
//

import UIKit
import Alamofire

class AuthViewController: UIViewController {

    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    private var isKeyboardAppeared = false
    private var oldSingInButtonHeight: CGFloat?

    private let appRepository = AppRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if !isKeyboardAppeared {
            oldSingInButtonHeight = self.view.frame.size.height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.size.height -= keyboardSize.height
                self.view.layoutIfNeeded()
            })
            self.tokenTextField.layer.borderColor = UIColor.colorThree.cgColor
            isKeyboardAppeared = true
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let oldValue = oldSingInButtonHeight else { return }

        if isKeyboardAppeared {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.size.height = oldValue
                self.view.layoutIfNeeded()
            })
            self.tokenTextField.layer.borderColor = UIColor.colorTwo.cgColor
            isKeyboardAppeared = false
        }
    }

    @IBAction func tapSingInButton(_ sender: Any) {

        guard let token = tokenTextField.text else { return }
        var arrayRepo = [Repo]()

        appRepository.getPrivateRepositories(token: token) { [weak self] answer in
            switch answer {
            case .success(let data):
                arrayRepo = data
                let newVC = RepositoriesListViewController()
                newVC.configure(with: arrayRepo)
                self?.navigationController?.pushViewController(newVC, animated: true)
            case.failure(let error):
                print(error.localizedDescription)
                //self?.addAlert(error: error.localizedDescription)
            }
        }
    }

    private func keyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    private func setupTokenTextField() {
        tokenTextField.layer.borderWidth = 1
        tokenTextField.layer.borderColor = UIColor.colorTwo.cgColor
        tokenTextField.layer.cornerRadius = 8
        tokenTextField.textColor = .white
        tokenTextField.attributedPlaceholder = NSAttributedString(
            string: "Personal access token",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.translucentWhite]
        )
        tokenTextField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: tokenTextField.frame.height))
        tokenTextField.leftViewMode = .always
    }

    private func tapToBackground() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupView() {
        setNeedsStatusBarAppearanceUpdate()
        setupTokenTextField()
        keyboardObservers()
        tapToBackground()
    }
}
