//
//  BookTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import UIKit

class BookTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookTableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
    }
}
