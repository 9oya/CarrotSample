//
//  BookInfoTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit

class BookInfoTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookInfoTableCell"
    var cellHeight: CGFloat!
    
    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        titleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.numberOfLines = 1
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        subTitleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.numberOfLines = 3
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        let constraints = [
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 15),
            subTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        ]
        NSLayoutConstraint.activate(constraints)
        
        cellHeight = 50
    }
}
