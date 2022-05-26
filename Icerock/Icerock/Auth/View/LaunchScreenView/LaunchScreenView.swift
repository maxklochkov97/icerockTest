//
//  LaunchScreenView.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import UIKit

class LaunchScreenView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    private func loadNib() {
        guard let xibView = Bundle.main.loadNibNamed("LaunchScreenView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
    }

}
