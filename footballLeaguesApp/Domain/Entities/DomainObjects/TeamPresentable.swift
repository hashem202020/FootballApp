//
//  TeamsPresentable.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
public struct TeamPresentable {
    public let id: Int
    public let thumbnail: String
    public let name: String

    init(_ team: Team) {
        self.id = team.id
        self.thumbnail = team.crestURL ?? ""
        self.name = team.name ?? ""
    }
}
