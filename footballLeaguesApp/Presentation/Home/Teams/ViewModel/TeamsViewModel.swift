//
//  TeamsViewModel.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
import RxSwift

public final class TeamsViewModel {

    // MARK: - Properties
    private let repository: LeaguesRepository
    private let navigator: TeamsNavigator
    private let leagueSubject = BehaviorSubject<LeaguesPresentable?>(value: nil)
    private let teamsSubject = BehaviorSubject<[TeamPresentable]>(value: [])
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)

    private let leagueImageSubject = BehaviorSubject<String>(value: "doc")
    private let leagueNameSubject = BehaviorSubject<String>(value: "No League")
    private let leagueGamesSubject = BehaviorSubject<String>(value: "0 Games")
    private let leagueTeamsSubject = BehaviorSubject<String>(value: "0 Teams")

    public var list: Observable<[TeamPresentable]> { return self.teamsSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }

    public var leagueImage: Observable<String> {
        return leagueImageSubject.asObserver() }
    
    public var leagueName: Observable<String> {
        return leagueNameSubject.asObserver() }
    
    public var leagueGames: Observable<String> {
        return leagueGamesSubject.asObserver() }
    
    public var leagueTeams: Observable<String> {
        return leagueTeamsSubject.asObserver() }

    public let errorPresentation = PublishSubject<ErrorPresentation?>()
    public let selectItemSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()

    // MARK: - Methods

    public init(league: LeaguesPresentable, repository: LeaguesRepository, navigator: TeamsNavigator) {
        self.repository = repository
        self.navigator = navigator
        leagueSubject.onNext(league)
        configureLeagueData(league: league)
        loadData()
        subscribeToSelectItem()
    }
    
    private func loadData() {
        let id = try? leagueSubject.value()?.id
        isLoadingSubject.onNext(true)
        repository.getTeams(id: "\(id ?? 0)")
            .asObservable()
            .subscribe {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.teamsSubject.onNext($0)
            } onError: { [weak self] in
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
                self?.isLoadingSubject.onNext(false)
            } onCompleted: {[weak self] in
                self?.isLoadingSubject.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    private func configureLeagueData(league: LeaguesPresentable){
        leagueImageSubject.onNext(league.thumbnail)
        leagueNameSubject.onNext(league.title)
        leagueGamesSubject.onNext(league.gamesCount)
        leagueTeamsSubject.onNext(league.teamsCount)

    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .compactMap { try? self.teamsSubject.value()[$0] }
            .subscribe(onNext: { [weak self] in
                self?.navigator.NavigateToTeamDetails(with: $0)
            }).disposed(by: disposeBag)
    }

}
