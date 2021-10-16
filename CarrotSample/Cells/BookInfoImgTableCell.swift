//
//  BookInfoImgTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit

class BookInfoImgTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookInfoImgTableCell"
    var cellHeight: CGFloat!
    
    var bookImgView: UIImageView!
    
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
        
        addSubview(bookImgView)
        
        let constraints = [
            bookImgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            bookImgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookImgView.heightAnchor.constraint(equalTo: heightAnchor),
            bookImgView.widthAnchor.constraint(equalTo: bookImgView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        cellHeight = 400
    }
}
