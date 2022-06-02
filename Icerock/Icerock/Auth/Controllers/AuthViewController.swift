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

    private var isKeyboardAppeared = false
    private var oldSingInButtonHeight: CGFloat?
    private var newSingInButtonHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        keyboardObservers()
    }

    private func setupView() {
        oldSingInButtonHeight = self.view.frame.size.height
        authView.tapButtonAuthVCDelegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func isValidToken(_ token: String) -> Bool {
        let lowercaseLetters = CharacterSet(charactersIn: "а"..."я")
        let uppercaseLetters = CharacterSet(charactersIn: "А"..."Я")

        if token.rangeOfCharacter(from: lowercaseLetters) != nil || token.rangeOfCharacter(from: uppercaseLetters) != nil {
            self.authView.invalidTokenLabel.isHidden = false
            self.authView.tokenTextField.layer.borderColor = UIColor.invalidToken.cgColor
            return false
        } else {
            return true
        }
    }

    private func addAlert() {
        self.defaultStateOfTheKeyboard()
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.alpha = 0
        self.view.addSubview(blurVisualEffectView)

        UIView.animate(withDuration: 0.2) {
            blurVisualEffectView.alpha = 1
        }

        let attributedTitle = NSAttributedString(
            string: NSLocalizedString("authVC.alert.title", comment: ""),
            attributes: [
                NSAttributedString.Key.font:
                    UIFont.systemFont(ofSize: 17, weight: .semibold),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])

        let attributedMessage = NSAttributedString(
            string: NSLocalizedString("authVC.alert.message", comment: ""),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        let okAlert = UIAlertAction(
            title: NSLocalizedString("authVC.alert.ok", comment: ""),
            style: .default) { _ in

                UIView.animate(withDuration: 0.2) {
                    blurVisualEffectView.alpha = 0
                } completion: { (_) in
                    blurVisualEffectView.removeFromSuperview()
                }
                self.dismiss(animated: true)
            }

        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.background
        alert.view.tintColor = UIColor.okAlert
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
