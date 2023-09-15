//
//  TeamsViewController.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import UIKit
import RxSwift
import RxDataSources

class TeamsViewController: NiblessViewController {

    // MARK: - Properties

    private let viewModel: TeamsViewModel
    private let customView: TeamsView
    
    private let teamsHeaderView: TeamsHeaderView
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, TeamPresentable>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TeamPresentable>>(
            configureCell: { (_, tableView, indexPath, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell" , for: indexPath) as? TeamTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: element)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
            }
        )
        return dataSource
    }()
    private let disposeBag = DisposeBag()

    // MARK: - Methods
    
    init(view: TeamsView, viewModel: TeamsViewModel ) {
        self.customView = view
        self.viewModel = viewModel
        self.teamsHeaderView = TeamsHeaderView(leagueImageObservable: viewModel.leagueImage, titleObservable: viewModel.leagueName, gamesObservable: viewModel.leagueGames, teamsObservable: viewModel.leagueTeams)
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTitle()
        subscribe(to: viewModel.list)
        subscribe(to: viewModel.isLoading)
        observeErrorMessages()
        customView.tableView.tableHeaderView = teamsHeaderView
        customView.tableView.tableHeaderView?.frame.size = CGSize(
            width: customView.tableView.tableHeaderView?.frame.size.width ?? 0, height: 100)
        subscribeToSelectedItem()

    }
    private func subscribe(to observable: Observable<[TeamPresentable]>) {
        observable
            .map { [SectionModel(model: "Teams", items: $0)] }
            .bind(to: customView.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
    
    private func subscribe(to observable: Observable<Bool>) {
        observable
            .subscribe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] loading in
            guard let strongSelf = self else { return }
            strongSelf.customView.loadingIndicator.isHidden = !loading
            guard loading else {
                strongSelf.customView.loadingIndicator.stopAnimating()
                return
            }
            strongSelf.customView.loadingIndicator.startAnimating()
        }).disposed(by: disposeBag)
    }
    
    private func observeErrorMessages() {
        viewModel
            .errorMessages
            .compactMap { $0 }
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.present(errorMessage: errorMessage,
                                   withPresentationState: strongSelf.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }

    private func settingTitle() {
        viewModel.leagueName
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.title = $0
            }.disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedItem() {
        customView.tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectItemSubject)
            .disposed(by: disposeBag)
    }

}
