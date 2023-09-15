//
//  TeamViewController.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import RxSwift
import RxDataSources

class TeamViewController: NiblessViewController {

// MARK: - Properties

    private let viewModel: TeamViewModel
    private let customView: TeamView

    private let teamHeaderView: TeamHeaderView

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, MatchPresentable>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MatchPresentable>>(
            configureCell: { (_, tableView, indexPath, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell" , for: indexPath) as? MatchTableViewCell else {
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
    
    init(view: TeamView, viewModel: TeamViewModel ) {
        self.customView = view
        self.viewModel = viewModel
        self.teamHeaderView = TeamHeaderView(teamImageObservable: viewModel.teamImage,
                                             teamNameObservable: viewModel.teamName)
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.list)
        subscribe(to: viewModel.isLoading)
        observeErrorMessages()
        customView.tableView.tableHeaderView = teamHeaderView
        customView.tableView.tableHeaderView?.frame.size = CGSize(
            width: customView.tableView.tableHeaderView?.frame.size.width ?? 0, height: 120)


    }

    private func subscribe(to observable: Observable<[MatchPresentable]>) {
        observable
            .map { [SectionModel(model: "Games", items: $0)] }
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

}
