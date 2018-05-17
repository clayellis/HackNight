//
//  File.swift
//  Yahtzee
//
//  Created by Danny Harding on 5/10/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

class MainView: UIView {
    let header = HeaderView()
    let scoreOptions = UICollectionView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.backgroundColor = .white

        setupHeader()
        setupScoreOptions()
    }

    func setupHeader() {
        header.backgroundColor = .red
        addAutoLayoutSubview(header)
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor),
            header.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            header.topAnchor.constraint(equalTo: self.topAnchor)
            ])
    }

    func setupScoreOptions() {
//        scoreOptions.dataSource = ?
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
