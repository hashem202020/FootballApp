//
//  LeaguesPersistentImple.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
import SQLite
import RxSwift

final public class LeaguesPersistentImple: LeaguesPersistent {
    
    public func saveLeagues(with remoteLeagues: [LeaguesPresentable]) {
        
        let databaseFileName = "dbtest.sqlite3"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"

        do {
            let db = try Connection(databaseFilePath)

            let leagues = Table("leagues")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let teamsCount = Expression<String>("teamsCount")
            let gamesCount = Expression<String>("gamesCount")
            let thumbnail = Expression<String>("thumbnail")

            try db.run(leagues.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(teamsCount)
                t.column(gamesCount)
                t.column(thumbnail)
            })
            for league in remoteLeagues {
                let insert = leagues.insert(id <- Int64(league.id), name <- league.title, teamsCount <- league.teamsCount, gamesCount <- league.gamesCount, thumbnail <- league.thumbnail  )
                 try db.run(insert)

            }
        } catch {
            print (error)
        }

    }
    
    public func getPersistentLeagues() -> Single<[LeaguesPresentable]> {
        var result: [LeaguesPresentable] = []
        
        let databaseFileName = "dbtest.sqlite3"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        do {
            let db = try Connection(databaseFilePath)
            let leagues = Table("leagues")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let teamsCount = Expression<String>("teamsCount")
            let gamesCount = Expression<String>("gamesCount")
            let thumbnail = Expression<String>("thumbnail")

            for league in try db.prepare(leagues) {
                result.append(LeaguesPresentable.init(id: league[id], name: league[name], teamsCount: league[teamsCount], gamesCount: league[gamesCount], thumbnail: league[thumbnail]))
            }
        } catch {
            print (error)
        }
        return Single.create { single in
            single(.success(result))
            return Disposables.create()
        }
    }

}
