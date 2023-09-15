//
//  LeaguesPresentable.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 29/04/2022.
//

import Foundation

public struct LeaguesPresentable {
    public let id: Int
    public let title: String
    public let teamsCount: String
    public let gamesCount: String
    public let thumbnail: String

    init(_ competition: Competition) {
        self.id = competition.id
        self.thumbnail = competition.emblemURL ?? ""
        self.title = competition.name ?? ""
        self.teamsCount = "\(competition.currentSeason?.currentMatchday ?? 0) teams"
        self.gamesCount = "\(competition.numberOfAvailableSeasons ?? 0) games"
    }
    
    init(id: Int64, name: String, teamsCount: String, gamesCount: String, thumbnail: String) {
        self.id = Int(id)
        self.title = name
        self.teamsCount = teamsCount
        self.gamesCount = gamesCount
        self.thumbnail = thumbnail
    }
}
