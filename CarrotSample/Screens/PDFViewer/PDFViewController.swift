//
//  PDFViewController.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit
import PDFKit

protocol PDFViewProtocol {
    func loadPdfDocs(document: PDFDocument)
}

class PDFViewController: UIViewController, PDFViewProtocol {
    
    var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView = {
            let pdfView = PDFView()
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.translatesAutoresizingMaskIntoConstraints = false
            return pdfView
        }()
        
        view.addSubview(pdfView)
        
        let constraints = [
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            pdfView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func loadPdfDocs(document: PDFDocument) {
        pdfView.document = document
        pdfView.setNeedsLayout()
    }
}
