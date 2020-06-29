//
//  SeasonHeaderViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

public final class SeasonHeaderViewModel {
  
  var showName: String  = ""
  
  private let showDetail: TVShowDetailResult
  
  public init(showDetail: TVShowDetailResult) {
    self.showDetail = showDetail
    setupUI()
  }
  
  private func setupUI() {
    if let name = showDetail.name {
      showName = name
    }
    
    if let years = showDetail.releaseYears {
      showName += " (" + years + ")"
    }
  }
}