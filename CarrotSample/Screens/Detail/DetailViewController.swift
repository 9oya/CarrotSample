//
//  DetailViewController.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit

protocol DetailViewInput {
    func setupInitialState()
    func layoutViews()
}

protocol DetailViewOutput {
    func viewIsReady()
    func loadBookInfo(isbn: String)
}

class DetailScreenConfigurator {
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController,
                                                       interactorDependency: DetailInteractor.Dependency) {
        if let viewController = viewInput as? DetailViewController {
            configure(viewController: viewController,
                      dependency: interactorDependency)
        }
    }
    
    private func configure(viewController: DetailViewController,
                           dependency: DetailInteractor.Dependency) {
        let presenter = DetailPresenter()
        presenter.view = viewController
        let interactor = DetailInteractor()
        interactor.dependency = dependency
        interactor.output = presenter
        presenter.interactor = interactor
        viewController.output = presenter
    }
}

class DetailViewController: UIViewController {
    
    var output: DetailViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension DetailViewController: DetailViewInput {
    func setupInitialState() {
        view.backgroundColor = .orange
    }
    
    func layoutViews() {
        
    }
}
