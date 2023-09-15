//
//  ViewController.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 27/04/2022.
//

import UIKit
import RxSwift
import RxDataSources

class LeaguesViewController: NiblessViewController {

    // MARK: - Properties

    private let viewModel: LeaguesViewModel
    private let customView: LeaguesView

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, LeaguesPresentable>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LeaguesPresentable>>(
            configureCell: { (_, tableView, indexPath, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesTableViewCell" , for: indexPath) as? LeaguesTableViewCell else {
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
    
    init(view: LeaguesView, viewModel: LeaguesViewModel ) {
        self.customView = view
        self.viewModel = viewModel
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Football Leagues"
        subscribe(to: viewModel.list)
        subscribe(to: viewModel.isLoading)
        observeErrorMessages()
        subscribeToSelectedItem()
        
        if #available(iOS 11.0, *) {
            navigationItem.backButtonTitle = ""
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        }

    }
    
    private func subscribe(to observable: Observable<[LeaguesPresentable]>) {
        observable
            .map { [SectionModel(model: "Leagues", items: $0)] }
            .bind(to: customView.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
    
    private func subscribe(to observable: Observable<Bool>) {
        observable
            .subscribe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] loading in
            guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.customView.loadingIndicator.isHidden = !loading
                    guard loading else {
                        strongSelf.customView.loadingIndicator.stopAnimating()
                        return
                    }
                    strongSelf.customView.loadingIndicator.startAnimating()

                }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedItem() {
        customView.tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectItemSubject)
            .disposed(by: disposeBag)
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


