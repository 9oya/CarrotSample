//
//  BookModel.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/14.
//

import Foundation

struct BookSearchResult: Codable {
    let total: String
    let page: String
    let books: [BookSearchModel]?
}

struct BookSearchModel: Codable {
    let title: String
    let subtitle: String?
    let isbn13: String
    let price: String
    let image: String?
    let url: String?
}
