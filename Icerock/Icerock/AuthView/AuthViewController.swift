//
//  LoginViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 13.05.2022.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var invalidTokenLabel: UILabel!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    private var isKeyboardAppeared = false
    private var oldSingInButtonHeight: CGFloat?
    private var newSingInButtonHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationBySavedToken()
        setupView()
    }

    private func setupView() {
        downloadImage.isHidden = true
        invalidTokenLabel.isHidden = true
        blurEffectView.isHidden = true
        setupTokenTextField()
        keyboardObservers()
        tapToBackground()
    }

    private func stopAnimate() {
        downloadImage.layer.removeAllAnimations()
        downloadImage.isHidden = true
        singInButton.titleLabel?.isHidden = false
    }

    private func startAnimate() {
        downloadImage.rotate()
        singInButton.titleLabel?.isHidden = true
        downloadImage.isHidden = false
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

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if !isKeyboardAppeared {
            oldSingInButtonHeight = self.view.frame.size.height

            UIView.animate(withDuration: 0.2, animations: {
                if let newHeight = self.newSingInButtonHeight {
                    self.view.frame.size.height = newHeight
                    self.view.layoutIfNeeded()
                } else {
                    self.view.frame.size.height -= keyboardSize.height
                    self.newSingInButtonHeight = self.view.frame.size.height
                    self.view.layoutIfNeeded()
                }
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

    private func isValidToken(_ token: String) -> Bool {
        let lowercaseLetters = CharacterSet(charactersIn: "а"..."я")
        let uppercaseLetters = CharacterSet(charactersIn: "А"..."Я")

        if token.rangeOfCharacter(from: lowercaseLetters) != nil || token.rangeOfCharacter(from: uppercaseLetters) != nil {
            self.invalidTokenLabel.isHidden = false
            self.tokenTextField.layer.borderColor = UIColor.colorSix.cgColor
            return false
        } else {
            return true
        }
    }

    @IBAction func tapSingInButton(_ sender: Any) {

        guard let token = tokenTextField.text, !token.isEmpty, isValidToken(token) else { return }
        startAnimate()

        NetworkManager.signIn(token: token) { [weak self] answer in
            switch answer {
            case .success(let token):
                self?.invalidTokenLabel.isHidden = true
                KeyValueStorage.userDefaults.setValue(token, forKey: "token")
                KeyValueStorage.authToken = token
                let newVC = RepositoriesListViewController()
                self?.navigationController?.pushViewController(newVC, animated: true)
                self?.stopAnimate()
            case.failure(let error):
                self?.stopAnimate()
                self?.addAlert(error: error.localizedDescription)
            }
        }
    }

    private func authorizationBySavedToken() {
        guard let oldToken = KeyValueStorage.userDefaults.value(forKey: "token") as? String else { return }

        NetworkManager.signIn(token: oldToken) { [weak self] answer in
            switch answer {
            case .success(_):
                let newVC = RepositoriesListViewController()
                self?.navigationController?.pushViewController(newVC, animated: false)
            case.failure(let error):
                self?.addAlert(error: error.localizedDescription)
            }
        }
    }

    private func addAlert(error: String) {
        blurEffectView.isHidden = false

        let attributedTitle = NSAttributedString(string: "Error", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ])

        let attributedMessage = NSAttributedString(string: error, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ])

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        let okAlert = UIAlertAction(title: "Ok", style: .default) { _ in
            self.blurEffectView.isHidden = true
            self.dismiss(animated: true)
        }
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.colorFive
        alert.view.tintColor = UIColor.colorFour

        alert.addAction(okAlert)
        present(alert, animated: true)
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

    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}


/*
 @IBAction func tapSingInButton(_ sender: Any) {

     guard let token = tokenTextField.text, !token.isEmpty, isValidToken(token) else { return }
     startAnimate()

     NetworkManager.getRepositories(token: token) { [weak self] answer in
         switch answer {
         case .success(let data):
             self?.invalidTokenLabel.isHidden = true
             let newVC = RepositoriesListViewController()
             newVC.configure(with: data)
             KeyValueStorage.userDefaults.setValue(token, forKey: "token")
             newVC.savedToken = token
             self?.navigationController?.pushViewController(newVC, animated: true)
             self?.stopAnimate()
         case.failure(let error):
             self?.stopAnimate()
//                let errors = "URLSessionTask failed with error: The Internet connection appears to be offline."
//
//                if error.localizedDescription == errors {
//                    print("PPpppp")
//                }
             self?.addAlert(error: error.localizedDescription)
         }
     }
 }
 */
