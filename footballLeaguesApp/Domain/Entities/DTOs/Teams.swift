//
//  Teams.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation

// MARK: - Welcome
public struct Teams: Codable {
    let count: Int?
    let competition: Competition?
    let season: Season?
    let teams: [Team]
}

// MARK: - Season
struct Season: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int
}

// MARK: - Team
public struct Team: Codable {
    let id: Int
    let area: Area?
    let name, shortName: String?
    let tla: String?
    let crestURL: String?
    let address: String?
    let phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let clubColors: String?
    let venue: String?

    enum CodingKeys: String, CodingKey {
        case id, area, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue
    }
}
