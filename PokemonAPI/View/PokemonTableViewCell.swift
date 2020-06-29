//
//  PokemonTableViewCell.swift
//  PokemonAPI
//
//  Created by Mark Kim on 6/27/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    static let identifier = "PokemonCell"
    
    let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpBackground()
    }
    
    func setUpBackground() {
        self.contentView.addSubview(background)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
}
