//
//  BookInfoModel.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import Foundation

struct BookInfoModel: Codable {
    let error: String?
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String?
    let language: String?
    let isbn10: String?
    let isbn13: String
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    let price: String?
    let image: String?
    let url: String?
    
    let pdf: [String:String]?
}

