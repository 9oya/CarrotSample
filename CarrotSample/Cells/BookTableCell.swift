//
//  BookTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import UIKit

class BookTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookTableCell"
    
    var bookImgView: UIImageView!
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
        bookImgView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        titleLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        subTitleLabel = {
            let label = UILabel()
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addSubview(bookImgView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        let constraints = [
            bookImgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            bookImgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookImgView.widthAnchor.constraint(equalToConstant: 50),
            bookImgView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: bookImgView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: bookImgView.rightAnchor, constant: 15),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leftAnchor.constraint(equalTo: bookImgView.rightAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
