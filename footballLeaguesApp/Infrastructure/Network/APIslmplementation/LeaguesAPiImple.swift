//
//  LeaguesAPiImple.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 29/04/2022.
//

import Foundation
import RxSwift
import Moya

final public class LeaguesAPiImple: LeaguesAPI {
    
    // MARK: - Properties
    private let leaguesProvider = MoyaProvider<LeaguesService>( plugins: [NetworkLoggerPlugin()])
    //MARK: - Methods
    
    public init() {}
    
    @available(iOS 15.0.0, *)
    public func getAsyncLeagues() async throws -> Leagues {
        let url = URL(string: "http://api.football-data.org/v2/competitions")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ErrorMessage(title: "", message: "serverError") }
        
        guard let decoded = try? JSONDecoder().decode(Leagues.self, from: data) else { throw ErrorMessage(title: "", message: "Decoding Error") }
        return decoded
    }

    public func getLeagues() -> Single<Leagues> {
        return Single.create { single in
            self.leaguesProvider.rx.request(.readLeagues).subscribe({ result in
                switch result {
                case .success(let response):
                    do {
                        let leagues = try JSONDecoder().decode(Leagues.self, from: response.data)
                        single(.success(leagues))
                    } catch let jsonError {
                        single(.failure(ErrorMessage(error: jsonError)))
                    }
                case .failure(let error):
                    single(.failure(ErrorMessage(error: error)))
                }
            })
            
        }
    }
    
    public func getTeams(id: String) -> Single<Teams> {
        return Single.create { single in
            self.leaguesProvider.rx.request(.readTeams(id: id)).subscribe({ result in
                switch result {
                case .success(let response):
                    do {
                        let teams = try JSONDecoder().decode(Teams.self, from: response.data)
                        single(.success(teams))
                    } catch let jsonError {
                        single(.failure(ErrorMessage(error: jsonError)))
                    }
                case .failure(let error):
                    single(.failure(ErrorMessage(error: error)))

                }
            })
        }
    }
    
    public func getTeamDetails(id: String) -> Single<TeamDetails> {
        return Single.create { single in
            self.leaguesProvider.rx.request(.readMatches(id: id)).subscribe({ result in
                switch result {
                case .success(let response):
                    do {
                        let details = try JSONDecoder().decode(TeamDetails.self, from: response.data)
                        single(.success(details))
                    } catch let jsonError {
                        single(.failure(ErrorMessage(error: jsonError)))
                    }
                case .failure(let error):
                    single(.failure(ErrorMessage(error: error)))

                }
            })
        }
    }
}
