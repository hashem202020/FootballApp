//
//  LeaguesService.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 29/04/2022.
//

import Foundation
import Moya

enum LeaguesService {
    case readLeagues
    case readTeams(id: String)
    case readMatches(id: String)
}

extension LeaguesService: TargetType{
    var baseURL: URL {
        return URL(string: "http://api.football-data.org/v2") ?? URL(string: "www.google.com")!
    }
    
    var path: String {
        switch self {
        case .readLeagues:
            return "/competitions"
        case .readTeams(let id):
            return "/competitions/\(id)/teams"
        case .readMatches(let id):
            return "/teams/\(id)/matches"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .readLeagues:
            return .get
        case .readTeams(_):
            return .get
        case .readMatches(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .readLeagues:
            return .requestPlain
        case .readTeams(_):
            return .requestPlain
        case .readMatches(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["X-Auth-Token": "a473c2a3f8db4e1391047a9f818f8f1a"]
    }
    
    
}
