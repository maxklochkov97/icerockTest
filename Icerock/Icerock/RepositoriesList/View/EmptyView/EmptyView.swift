//
//  EmptyView.swift
//  Icerock
//
//  Created by Максим Клочков on 24.05.2022.
//

import UIKit

class EmptyView: UIView {

    weak var updateReposDelegate: UpdateReposDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    @IBAction func tapButton(_ sender: Any) {
        updateReposDelegate?.getRepos()
    }

    private func loadNib() {
        guard let xibView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
    }

}
