//
//  BookTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import UIKit

class BookTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookTableCell"
    var cellHeight: CGFloat!
    
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
            label.font = .systemFont(ofSize: 16)
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        subTitleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.numberOfLines = 2
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
            bookImgView.heightAnchor.constraint(equalTo: heightAnchor),
            bookImgView.widthAnchor.constraint(equalTo: bookImgView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: bookImgView.rightAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leftAnchor.constraint(equalTo: bookImgView.rightAnchor, constant: 15),
            subTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        ]
        NSLayoutConstraint.activate(constraints)
        
        cellHeight = 100
    }
}
