//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultTVShowsRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - TVShowsRepository

extension DefaultTVShowsRepository: TVShowsRepository {
    
    func tvShowsList(page: Int,
                     completion: @escaping (Result<TVShowResult, Error>) -> Void) -> Cancellable? {
        
        let endPoint: TVShowsProvider = .getAiringTodayShows(page)
        
        let networkTask = dataTransferService.request(service: endPoint,
                         decodeType: TVShowResult.self,
                         completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
}