//
//  UIView+Extension.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit

extension UIView {
    func showSpinner() {
        let spinner: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView()
            indicator.style = UIActivityIndicatorView.Style.large
            indicator.color = .black
            indicator.startAnimating()
            indicator.tag = 475647
            indicator.translatesAutoresizingMaskIntoConstraints = false
            return indicator
        }()
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func hideSpinner() {
        if let spinner = viewWithTag(475647){
            spinner.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
