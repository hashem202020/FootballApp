//
//  DefaultLeagueRepositoryImple.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import Foundation
import RxSwift
import SQLite

final public class DefaultLeagueRepositoryImple: LeaguesRepository {
    
    // MARK: - Properties
    
    private let remoteAPI: LeaguesAPI
    private let persistentData: LeaguesPersistent
    private let disposeBag = DisposeBag()
    
    //MARK: - Methods
    
    public init(remoteAPI: LeaguesAPI, persistentData: LeaguesPersistent) {
        self.remoteAPI = remoteAPI
        self.persistentData = persistentData
    }
    
    public func getRemoteLeagues() -> Single<[LeaguesPresentable]> {
        remoteAPI
            .getLeagues()
            .map{ $0.competitions.sorted { $0.id < $1.id }.map(LeaguesPresentable.init) }
            .asObservable()
            .asSingle()
    }
    
    public func getTeams(id: String) -> Single<[TeamPresentable]> {
        remoteAPI
            .getTeams(id: id)
            .map{ $0.teams.map(TeamPresentable.init) }
            .asObservable()
            .asSingle()
    }
    
    public func getTeamDetails(id: String) -> Single<[MatchPresentable]> {
        remoteAPI
            .getTeamDetails(id: id)
            .map{ $0.matches.map(MatchPresentable.init) }
            .asObservable()
            .asSingle()
        
    }
    
    public func savePersistentLeague(with leagues: [LeaguesPresentable]) {
        persistentData
            .saveLeagues(with: leagues)
    }
    
    public func getPersistentLeague() -> Single<[LeaguesPresentable]> {
        persistentData
            .getPersistentLeagues()
            .map{ $0 }
            .asObservable()
            .asSingle()
    }
    
    /// this function returns leagues and a flag to the loading indicator to differentiate if the data from remote or from persistent
    public func getLeagues() -> Single<([LeaguesPresentable], Bool)> {
        return Single.create { single in
            self.getPersistentLeague().subscribe { [weak self] persistentResult in
                guard let strongSelf = self else { return }
                switch persistentResult {
                case .success(let persistentData):
                    if persistentData.count == 0 {
                        
                        strongSelf.getRemoteLeagues()
                            .subscribe { [weak self] remoteResult in
                                switch remoteResult {
                                case .success(let remoteData):
                                    single(.success((remoteData, true)))
                                    self?.persistentData.saveLeagues(with: remoteData)
                                case .failure(let error):
                                    single(.failure(error))
                                }
                            }.disposed(by: strongSelf.disposeBag)
                        
                    } else {
                        single(.success((persistentData, false)))
                        
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    public func getRemoteLeaguesAsync() async throws -> [LeaguesPresentable] {
        let presentableLeagues = try await remoteAPI.getAsyncLeagues().competitions.sorted(by: { $0.id < $1.id }).map( LeaguesPresentable.init )
        
        return presentableLeagues
    }

}
