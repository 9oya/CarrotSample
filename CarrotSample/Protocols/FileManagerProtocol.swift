//
//  FileManagerProtocol.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation

protocol FileManagerProtocol {
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool
    func fileExists(atPath path: String) -> Bool
}

extension FileManager: FileManagerProtocol {
}
