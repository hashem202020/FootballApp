//
//  LeaguesRepository.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import Foundation
import RxSwift

public protocol LeaguesRepository {
    func getRemoteLeagues() -> Single<[LeaguesPresentable]>
    func getTeams(id: String) -> Single<[TeamPresentable]>
    func getTeamDetails(id: String) -> Single<[MatchPresentable]>
    func savePersistentLeague(with leagues: [LeaguesPresentable])
    func getPersistentLeague() -> Single<[LeaguesPresentable]>
    func getLeagues() -> Single<([LeaguesPresentable], Bool)>
    
    @available(iOS 15.0.0, *)
    func getRemoteLeaguesAsync() async throws -> [LeaguesPresentable]
}
