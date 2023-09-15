//
//  LeaguesAPI.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 29/04/2022.
//

import Foundation
import RxSwift

public protocol LeaguesAPI {
    func getLeagues() -> Single<Leagues>
    func getTeams(id: String) -> Single<Teams>
    func getTeamDetails(id: String) -> Single<TeamDetails>
    
    @available(iOS 15.0.0, *)
    func getAsyncLeagues() async throws -> Leagues
}
