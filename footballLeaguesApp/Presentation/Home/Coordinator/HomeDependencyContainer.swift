//
//  HomeDependencyContainer.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import UIKit

class HomeDependencyContainer {
    
    // MARK: - Properties
        
    // Long-lived dependencies
    private let sharedHomeViewModel: HomeNavigationViewModel

    init() {
        func makeHomeViewModel() -> HomeNavigationViewModel {
            return HomeNavigationViewModel()
        }
        
        self.sharedHomeViewModel = makeHomeViewModel()
    }
    
    public func makeHomeViewController() -> HomeViewController {
        
        let teamsDetailsViewControllerFactory = { [weak self] (league: LeaguesPresentable) -> TeamsViewController in
            guard let strongSelf = self else { fatalError("Unexpected error from Dependency Container") }
            let viewModel = strongSelf.makeTeamsViewModel(league: league)
            return strongSelf.makeTeamsViewController(viewModel: viewModel)
        }
        
        let teamViewControllerFactory = { [weak self] (team: TeamPresentable) -> TeamViewController in
            guard let strongSelf = self else { fatalError("Unexpected error from Dependency Container") }
            let viewModel = strongSelf.makeTeamViewModel(team: team)
            return strongSelf.makeTeamViewController(viewModel: viewModel)
        }
        
        return HomeViewController(viewModel: sharedHomeViewModel,
                                  rootViewController: makeLeaguesViewController(),
                                  teamsViewControllerFactory: teamsDetailsViewControllerFactory,
                                  teamViewControllerFactory: teamViewControllerFactory)
    }
    
    // Root (League)
    
    private func makeLeaguesViewController() -> LeaguesViewController {
        LeaguesViewController(view: LeaguesView(), viewModel: makeLeaguesViewModel())
    }
    
    private func makeLeaguesViewModel() -> LeaguesViewModel {
        LeaguesViewModel(repository: makeLeaguesRepository(), navigator: sharedHomeViewModel)
    }
    
    private func makeLeaguesRepository() -> LeaguesRepository {
        DefaultLeagueRepositoryImple(remoteAPI: LeaguesAPiImple(), persistentData: LeaguesPersistentImple())
    }
    
    // Teams
    
    private func makeTeamsViewController(viewModel: TeamsViewModel) -> TeamsViewController {
        TeamsViewController(view: TeamsView(), viewModel: viewModel)
    }
    
    private func makeTeamsViewModel(league: LeaguesPresentable) -> TeamsViewModel {
        TeamsViewModel(league: league, repository: makeLeaguesRepository(), navigator: sharedHomeViewModel)
    }

    // Team
    
    private func makeTeamViewController(viewModel: TeamViewModel) -> TeamViewController {
        TeamViewController(view: TeamView(), viewModel: viewModel)
    }
    
    private func makeTeamViewModel(team: TeamPresentable) -> TeamViewModel {
        TeamViewModel(team: team, repository: makeLeaguesRepository())
    }

}
