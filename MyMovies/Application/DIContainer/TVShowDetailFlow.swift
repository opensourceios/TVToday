//
//  TVShowDetailFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class TVShowDetailFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageTransferService: DataTransferService
    let apiDataTransferServiceReactive: DataTransferServiceReactive
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }

  private var rootViewController: UIViewController!
  
  // Repositories
  private lazy var showDetailsRepository: TVShowDetailsRepository = {
    return DefaultTVShowDetailsRepository(dataTransferService: dependencies.apiDataTransferService, dataTransferServiceReactive: dependencies.apiDataTransferServiceReactive)
  }()
  
  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  // MARK: - Life Cycle
  
  public init(rootViewController: UIViewController, dependencies: Dependencies) {
    self.rootViewController = rootViewController
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
      
    case ShowDetailsStep.showDetailsIsRequired(let showId):
      return showDetailsFeature(with: showId)
      
    case ShowDetailsStep.seasonsAreRequired(let showId):
      return navigateToSeasonsScreen(with: showId)
      
    default:
      return .none
    }
  }
  
  fileprivate func showDetailsFeature(with id: Int) -> FlowContributors {
    let viewModel = TVShowDetailViewModel(id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase())
    let detailVC = TVShowDetailViewController.create(with: viewModel)
    
    if let navigationVC = rootViewController as? UINavigationController {
      navigationVC.pushViewController(detailVC, animated: true)
    } else {
      rootViewController.present(detailVC, animated: true)
    }
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToSeasonsScreen(with id: Int) -> FlowContributors {
    let viewModel = EpisodesListViewModel(tvShowId: id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase(), fetchEpisodesUseCase: makeFetchEpisodesUseCase())
    let seasonsVC = EpisodesListViewController.create(with: viewModel)
    
    if let navigationVC = rootViewController as? UINavigationController {
      navigationVC.pushViewController(seasonsVC, animated: true)
    } else {
      rootViewController.present(seasonsVC, animated: true)
    }
    
    return .one(flowContributor: .contribute(
      withNextPresentable: seasonsVC, withNextStepper: viewModel))
  }
  
  
  // MARK: - Uses Cases
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
    return DefaultFetchTVShowDetailsUseCase(tvShowDetailsRepository: showDetailsRepository)
  }
  
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
     return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
   }
}


public enum ShowDetailsStep: Step {
  
  case
  
  showDetailsIsRequired(withId: Int),
  
  seasonsAreRequired(withId: Int)
}