//
//  HomeNavigationViewModel.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import Foundation
import RxSwift

public typealias HomeNavigationAction = NavigationAction<HomeView>

public class HomeNavigationViewModel: LeaguesNavigator, TeamsNavigator {

    // MARK: - Properties
    
    public var view: Observable<HomeNavigationAction> { return viewSubject.asObserver() }
    private let viewSubject = BehaviorSubject<HomeNavigationAction>(value: .present(view: .Leagues))

    // MARK: - Methods
    
    public init() {
        
    }
    
    public func uiPresented(view: HomeView) {
        viewSubject.onNext(.presented(view: view))
    }
    
    public func NavigateToTeams(with league: LeaguesPresentable) {
        viewSubject.onNext(.present(view: .Teams(league: league)))
    }
    
    public func NavigateToTeamDetails(with team: TeamPresentable) {
        viewSubject.onNext(.present(view: .Team(team: team)))
    }

}

public protocol LeaguesNavigator {
    func NavigateToTeams(with league: LeaguesPresentable)
}

public protocol TeamsNavigator {
    func NavigateToTeamDetails(with team: TeamPresentable)
}
