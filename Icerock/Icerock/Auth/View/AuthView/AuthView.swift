//
//  AuthView.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import UIKit

class AuthView: UIView {
    
    weak var tapButtonAuthVCDelegate: TapButtonAuthVCDelegate?
    
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var invalidTokenLabel: UILabel!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    
    private var isKeyboardAppeared = false
    private var oldSingInButtonHeight: CGFloat?
    private var newSingInButtonHeight: CGFloat?
    
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

    private func loadNib() {
        guard let xibView = Bundle.main.loadNibNamed("AuthView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    private func setupView() {
        downloadImage.isHidden = true
        invalidTokenLabel.isHidden = true
        setupTokenTextField()
        tapToBackground()
    }
    
    func stopAnimate() {
        downloadImage.layer.removeAllAnimations()
        downloadImage.isHidden = true
        singInButton.titleLabel?.isHidden = false
    }
    
    func startAnimate() {
        downloadImage.rotate()
        singInButton.titleLabel?.isHidden = true
        downloadImage.isHidden = false
    }
    
    private func setupTokenTextField() {
        tokenTextField.layer.borderWidth = 1
        tokenTextField.layer.borderColor = UIColor.colorTwo.cgColor
        tokenTextField.layer.cornerRadius = 8
        tokenTextField.textColor = .white
        tokenTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("authVC.tokenTextField.text", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.translucentWhite]
        )
        tokenTextField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: tokenTextField.frame.height))
        tokenTextField.leftViewMode = .always
    }
    
    private func tapToBackground() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
}
