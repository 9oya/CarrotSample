//
//  DetailInteractor.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

protocol DetailInteractorInput {
    func loadBookInfo(isbn: String)
}

protocol DetailInteractorOutput {
    func layoutViews()
}

class DetailInteractor {
    
    struct Dependency {
        let bookService: BookServiceProtocol!
        let memoryCacheService: MemoryCacheServiceProtocol!
        let diskCacheService: DiskCacheServiceProtocol!
    }
    
    var output: DetailInteractorOutput!
    var dependency: Dependency!
}

extension DetailInteractor: DetailInteractorInput {
    func loadBookInfo(isbn: String) {
        
    }
}
