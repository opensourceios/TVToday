//
//  TVShowDetailsSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

// MARK: - TODO Debería ser final class??

final class TVShowDetailsSceneDIContainer {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }

    private let dependencies: Dependencies

    // MARK: - Initializers

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController {
        return TVShowDetailViewController.create(
            with: makeTVShowDetailsViewModel(with: identifier),
            showDetailsViewControllersFactory: self)
    }
    
    public func makeSeasonsListViewController(with result: TVShowDetailResult) -> UIViewController {
        
        let dependenciesForSeasons = SeasonsListViewControllerDIContainer.Dependencies(
                apiDataTransferService: dependencies.apiDataTransferService,
                imageDataTransferService: dependencies.imageDataTransferService)
            
        let container = SeasonsListViewControllerDIContainer(dependencies: dependenciesForSeasons)
        
        return container.makeSeasonsListViewController(with: result)
    }
}

// MARK: - Private

extension TVShowDetailsSceneDIContainer {

    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes

    private func makeTVShowDetailsViewModel(with identifier: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(identifier,
                                     fetchDetailShowUseCase: makeFetchTVShowDetailsUseCase(),
                                     posterImagesRepository: makePosterImageRepository())
    }

    // MARK: - Use Cases

    private func makeFetchTVShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
        return DefaultFetchTVShowDetailsUseCase(
            tvShowDetailsRepository: makeTVShowDetailsRepository())
    }

    // MARK: - Repositories

    private func makeTVShowDetailsRepository() -> TVShowDetailsRepository {
        return DefaultTVShowDetailsRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    private func makePosterImageRepository() -> PosterImageRepository {
        return DefaultPosterImageRepository(dataTransferService: dependencies.imageDataTransferService,
                                            imageNotFoundData: UIImage(named: "placeholder")?.pngData() )
    }
}

// MARK: - TVShowDetailViewControllersFactory

extension TVShowDetailsSceneDIContainer: TVShowDetailViewControllersFactory {

}