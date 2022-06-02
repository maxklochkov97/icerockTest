//
//  ConnectionErrorView.swift
//  Icerock
//
//  Created by Максим Клочков on 25.05.2022.
//

import UIKit

class DetailConnectionErrorView: UIView {

    weak var updateDetailDelegate: UpdateDetailDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    @IBAction func tapButton(_ sender: Any) {
        updateDetailDelegate?.hiddenView()
        updateDetailDelegate?.loadData()
    }

    private func loadNib() {
        guard let xibView = Bundle.main.loadNibNamed("DetailConnectionErrorView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
    }
}
