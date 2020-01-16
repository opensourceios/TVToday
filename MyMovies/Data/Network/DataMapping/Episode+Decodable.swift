//
//  Episode+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension Episode: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case name
        case airDate = "air_date"
        case voteAverage =  "vote_average"
        case episodePath = "still_path"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.name = try container.decode(String.self, forKey: .name)
        self.airDate = try container.decode(String.self, forKey: .airDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.episodePath = try container.decode(String.self, forKey: .episodePath)
    }
}
