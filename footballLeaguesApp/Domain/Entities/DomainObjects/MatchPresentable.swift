//
//  MatchPresentable.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
public struct MatchPresentable {
    public let id: Int
    public let homeTeam: String
    public let awayTeam: String
    public let status: String
    public let homeScore: String
    public let awayScore: String
    public let homeLogo: String
    public let awayLogo: String
    
    init(_ match: Match) {
        self.id = match.id
        self.homeTeam = match.homeTeam?.name ?? ""
        self.awayTeam = match.awayTeam?.name ?? ""
        self.status = match.status ?? ""
        self.homeScore = "\(match.score?.fullTime?.homeTeam ?? 0)"
        self.awayScore = "\(match.score?.fullTime?.awayTeam ?? 0)"
        self.homeLogo = "\(match.homeTeam?.crestURL ?? "")"
        self.awayLogo = "\(match.awayTeam?.crestURL ?? "")"
    }
}
