//
//  BookModel.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/14.
//

import Foundation

//{
//    "total": "0",
//    "total": "48",
//    "page": "1",
//    "books": [
//        {
//            "title": "Practical MongoDB",
//            "subtitle": "Architecting, Developing, and Administering MongoDB",
//            "isbn13": "9781484206485",
//            "price": "$32.04",
//            "image": "https://itbook.store/img/books/9781484206485.png",
//            "url": "https://itbook.store/books/9781484206485"
//        },
//        {
//            title": "The Definitive Guide to MongoDB, 3rd Edition",
//            subtitle": "A complete guide to dealing with Big Data using MongoDB",
//            isbn13": "9781484211830",
//            price": "$47.11",
//            image": "https://itbook.store/img/books/9781484211830.png",
//            url": "https://itbook.store/books/9781484211830"
//        },
//        {
//            "title": "MongoDB in Action, 2nd Edition",
//            "subtitle": "Covers MongoDB version 3.0",
//            "isbn13": "9781617291609",
//            "price": "$32.10",
//            "image": "https://itbook.store/img/books/9781617291609.png",
//            "url": "https://itbook.store/books/9781617291609"
//        },
//        ...
//    ]
//}

struct SearchBookModel: Codable {
    let total: String
    let page: String
    let books: [BookModel]?
}

struct BookModel: Codable {
    let title: String
    let subtitle: String?
    let isbn13: String
    let price: String
    let image: String?
    let url: String?
}