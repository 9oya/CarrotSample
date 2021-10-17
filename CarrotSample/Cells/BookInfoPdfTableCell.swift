//
//  BookInfoPdfTableCell.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit
import PDFKit

class BookInfoPdfTableCell: UITableViewCell {
    
    static let reuseIdentifier = "BookInfoPdfTableCell"
    var cellHeight: CGFloat!
    
    var pdfView: PDFView!
    
    var swipeRight: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped back")
                if pdfView.canGoToPreviousPage {
                    pdfView.goToPreviousPage(nil)
                }
            case .left:
                if pdfView.canGoToNextPage {
                    pdfView.goToNextPage(nil)
                }
            default:
                break
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPdfDocs(url: URL) {
        let pdfDoc = PDFDocument(url: url)
        pdfView.document = pdfDoc
        pdfView.setNeedsLayout()
    }
    
    private func setupLayout() {
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        swipeLeft.direction = .left
        addGestureRecognizer(swipeRight)
        addGestureRecognizer(swipeLeft)
        
        pdfView = {
            let pdfView = PDFView()
            pdfView.autoScales = true
            pdfView.displayMode = .singlePage
            pdfView.displayDirection = .horizontal
            pdfView.translatesAutoresizingMaskIntoConstraints = false
            return pdfView
        }()
        
        addSubview(pdfView)
        
        let constraints = [
            pdfView.topAnchor.constraint(equalTo: topAnchor),
            pdfView.leftAnchor.constraint(equalTo: leftAnchor),
            pdfView.rightAnchor.constraint(equalTo: rightAnchor),
            pdfView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        cellHeight = 500
    }
}
