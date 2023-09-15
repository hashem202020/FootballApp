//
//  LeaguesViewModel.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import Foundation
import RxSwift

public final class LeaguesViewModel {
    
    // MARK: - Properties
    
    private let repository: LeaguesRepository
    private let competitionsSubject = BehaviorSubject<[LeaguesPresentable]>(value: [])
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let navigator: LeaguesNavigator

    public var list: Observable<[LeaguesPresentable]> { return self.competitionsSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }
    public let errorPresentation = PublishSubject<ErrorPresentation?>()
    public let selectItemSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()

    // MARK: - Methods

    public init(repository: LeaguesRepository, navigator: LeaguesNavigator) {
        self.repository = repository
        self.navigator = navigator

        if #available(iOS 15.0, *) {
            Task {
                await loadAsyncData()
            }
        } else {
            loadData()
        }
        
        subscribeToSelectItem()
    }
    
    
    @available(iOS 15.0.0, *)
    public func loadAsyncData() async {
        do {
            isLoadingSubject.onNext(true)
            competitionsSubject.onNext(try await repository.getRemoteLeaguesAsync())
            isLoadingSubject.onNext(false)

        } catch {
            errorMessagesSubject.onNext(ErrorMessage(error: error))

        }
    }
    
    private func loadData() {
        repository.getLeagues()
            .asObservable()
            .subscribe { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.isLoadingSubject.onNext($0.1)
                strongSelf.competitionsSubject.onNext($0.0)
            } onError: {[weak self] in
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
            } onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .compactMap { try? self.competitionsSubject.value()[$0] }
            .subscribe(onNext: { [weak self] in
                self?.navigator.NavigateToTeams(with: $0)
            }).disposed(by: disposeBag)
    }

}
