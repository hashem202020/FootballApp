//
//  TeamDetails.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
// MARK: - Welcome
public struct TeamDetails: Codable {
    let count: Int
    let matches: [Match]
}


// MARK: - Match
public struct Match: Codable {
    let id: Int
    let competition: Competition?
    let season: Season?
    let utcDate: String?
    let status: String?
    let matchday: Int?
    let group: String?
    let score: Score?
    let homeTeam, awayTeam: Team?
}

// MARK: - Score
public struct Score: Codable {
    let winner: WinnerTeam?
    let duration: String?
    let fullTime, halfTime, extraTime, penalties: Results?
}

// MARK: - ExtraTime
public struct Results: Codable {
    let homeTeam, awayTeam: Int?
}

enum WinnerTeam: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}
