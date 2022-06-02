//
//  AuthView.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class AuthView: UIView {
    
    weak var tapButtonAuthVCDelegate: TapButtonAuthVCDelegate?
    
    @IBOutlet weak var invalidTokenLabel: UILabel!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var activityIndicator: MDCActivityIndicator!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        setupView()
    }

    @IBAction func tapSingInButton(_ sender: Any) {
        tapButtonAuthVCDelegate?.singIn()
    }

    private func setupActivityIndicator() {
        activityIndicator.cycleColors = [.white]
        activityIndicator.radius = 12
        activityIndicator.strokeWidth = 3
    }

    private func loadNib() {
        guard let xibView = Bundle.main.loadNibNamed("AuthView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    private func setupView() {
        invalidTokenLabel.isHidden = true
        setupActivityIndicator()
        setupTokenTextField()
        tapToBackground()
    }
    
    func stopAnimate() {
        activityIndicator.stopAnimating()
        singInButton.setTitleColor(UIColor.white, for: .normal)
        //singInButton.titleLabel?.isHidden = false
    }
    
    func startAnimate() {
        singInButton.setTitleColor(UIColor.clear, for: .normal)
        //singInButton.titleLabel?.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func setupTokenTextField() {
        tokenTextField.layer.borderWidth = 1
        tokenTextField.layer.borderColor = UIColor.tokenTextFieldDefaultBorder.cgColor
        tokenTextField.layer.cornerRadius = 8
        tokenTextField.textColor = .white
        tokenTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("authVC.tokenTextField.text", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.tokenTextFieldText]
        )
        tokenTextField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: tokenTextField.frame.height))
        tokenTextField.leftViewMode = .always
        tokenTextField.delegate = self
    }
    
    private func tapToBackground() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
}

extension AuthView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tokenTextField {
            UIView.animate(withDuration: 0.2, animations: {
                self.tokenTextField.layer.borderColor = UIColor.tokenTextFieldActivBorder.cgColor
            })
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tokenTextField {
            UIView.animate(withDuration: 0.2, animations: {
                self.tokenTextField.layer.borderColor = UIColor.tokenTextFieldDefaultBorder.cgColor
            })
        }
    }
}
