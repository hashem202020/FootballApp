//
//  LeaguesPersistent.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
import RxSwift

public protocol LeaguesPersistent {
    func saveLeagues(with remoteLeagues: [LeaguesPresentable])
    func getPersistentLeagues() -> Single<[LeaguesPresentable]>
}
