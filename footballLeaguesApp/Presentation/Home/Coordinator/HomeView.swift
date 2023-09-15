//
//  HomeView.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

public enum HomeView: Equatable {
    case Leagues
    case Teams(league: LeaguesPresentable)
    case Team(team: TeamPresentable)
    
    public func hidesNavigationBar() -> Bool {
        return false
    }
    
    public static func == (lhs: HomeView, rhs: HomeView) -> Bool {
        switch (lhs, rhs) {
        case (.Leagues, .Leagues),
            (.Teams,.Teams): return true
        default: return false
        }
    }
}
