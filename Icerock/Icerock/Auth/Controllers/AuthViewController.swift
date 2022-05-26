//
//  TestViewController.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authView: AuthView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var launchScreenView: LaunchScreenView!

    private var isKeyboardAppeared = false
    private var oldSingInButtonHeight: CGFloat?
    private var newSingInButtonHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationBySavedToken()
        setupView()
        keyboardObservers()
    }

    private func setupView() {
        oldSingInButtonHeight = self.view.frame.size.height
        blurEffectView.isHidden = true
        authView.tapButtonAuthVCDelegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func authorizationBySavedToken() {
        launchScreenView.isHidden = true
         guard let oldToken = KeyValueStorage.userDefaults.value(forKey: "token") as? String else { return }
        scrollView.isHidden = true
        launchScreenView.isHidden = false

         NetworkManager.signIn(token: oldToken) { [weak self] answer in
             switch answer {
             case .success(_):
                 let newVC = RepositoriesListViewController()
                 self?.navigationController?.pushViewController(newVC, animated: false)
                 self?.launchScreenView.isHidden = true
                 self?.scrollView.isHidden = false
             case.failure(let error):
                 self?.launchScreenView.isHidden = true
                 self?.scrollView.isHidden = false
                 self?.addAlert()
                 print("Error in \(#function) == \(error.localizedDescription)")
             }
         }
     }

    private func isValidToken(_ token: String) -> Bool {
        let lowercaseLetters = CharacterSet(charactersIn: "а"..."я")
        let uppercaseLetters = CharacterSet(charactersIn: "А"..."Я")

        if token.rangeOfCharacter(from: lowercaseLetters) != nil || token.rangeOfCharacter(from: uppercaseLetters) != nil {
            self.authView.invalidTokenLabel.isHidden = false
            self.authView.tokenTextField.layer.borderColor = UIColor.colorSix.cgColor
            return false
        } else {
            return true
        }
    }

    private func addAlert() {
        blurEffectView.isHidden = false

        let attributedTitle = NSAttributedString(
            string: NSLocalizedString("authVC.alert.title", comment: ""),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])

        let attributedMessage = NSAttributedString(
            string: NSLocalizedString("authVC.alert.message", comment: ""),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        let okAlert = UIAlertAction(
            title: NSLocalizedString("authVC.alert.ok", comment: ""),
            style: .default) { _ in
                self.blurEffectView.isHidden = true
                self.dismiss(animated: true)
            }

        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.colorFive
        alert.view.tintColor = UIColor.colorFour

        alert.addAction(okAlert)
        present(alert, animated: true)
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        defaultStateOfTheKeyboard()
    }

    private func defaultStateOfTheKeyboard() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero

        guard let oldValue = oldSingInButtonHeight else { return }
        if isKeyboardAppeared {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.size.height = oldValue
                self.view.layoutIfNeeded()
            })
            isKeyboardAppeared = false
        }
        self.view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if UIDevice.current.orientation.isLandscape {
            scrollView.contentInset.top -= keyboardSize.height
        } else {
            if !isKeyboardAppeared {
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
                isKeyboardAppeared = true
            }
        }
        self.authView.tokenTextField.layer.borderColor = UIColor.colorThree.cgColor
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        if UIDevice.current.orientation.isLandscape {
            scrollView.contentInset = .zero
            scrollView.verticalScrollIndicatorInsets = .zero
        } else {
            guard let oldValue = oldSingInButtonHeight else { return }
            if isKeyboardAppeared {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame.size.height = oldValue
                    self.view.layoutIfNeeded()
                })
                isKeyboardAppeared = false
            }
        }
        self.authView.tokenTextField.layer.borderColor = UIColor.colorTwo.cgColor
    }
}

extension AuthViewController: TapButtonAuthVCDelegate {
    func singIn() {
        guard let token = authView.tokenTextField.text, !token.isEmpty, isValidToken(token) else { return }
        authView.startAnimate()

        NetworkManager.signIn(token: token) { [weak self] answer in
            switch answer {
            case .success(let token):
                self?.authView.invalidTokenLabel.isHidden = true
                KeyValueStorage.userDefaults.setValue(token, forKey: "token")
                KeyValueStorage.authToken = token
                let newVC = RepositoriesListViewController()
                self?.navigationController?.pushViewController(newVC, animated: true)
                self?.authView.stopAnimate()
            case.failure(let error):
                self?.authView.stopAnimate()
                self?.addAlert()
                print("Error in \(#function) == \(error.localizedDescription)")
            }
        }
    }
}
