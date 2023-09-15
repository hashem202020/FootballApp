//
//  TeamViewModel.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import Foundation
import RxSwift

public final class TeamViewModel {

    // MARK: - Properties
    private let repository: LeaguesRepository
    private let matchesSubject = BehaviorSubject<[MatchPresentable]>(value: [])
    private let teamsSubject = BehaviorSubject<TeamPresentable?>(value: nil)
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let teamImageSubject = BehaviorSubject<String>(value: "doc")
    private let teamNameSubject = BehaviorSubject<String>(value: "None")

    public var list: Observable<[MatchPresentable]> { return self.matchesSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }
    public var teamImage: Observable<String> {
        return teamImageSubject.asObserver() }
    public var teamName: Observable<String> {
        return teamNameSubject.asObserver() }

    public let errorPresentation = PublishSubject<ErrorPresentation?>()
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    public init(team: TeamPresentable, repository: LeaguesRepository) {
        self.repository = repository
        teamsSubject.onNext(team)
        teamImageSubject.onNext(team.thumbnail)
        teamNameSubject.onNext(team.name)

        loadData()
    }

    private func loadData() {
        let id = try? teamsSubject.value()?.id
        isLoadingSubject.onNext(true)
        repository.getTeamDetails(id: "\(id ?? 0)")
            .asObservable()
            .subscribe {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.matchesSubject.onNext($0)
            } onError: { [weak self] in
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
                self?.isLoadingSubject.onNext(false)
            } onCompleted: {[weak self] in
                self?.isLoadingSubject.onNext(false)
            }.disposed(by: disposeBag)
    }

}
