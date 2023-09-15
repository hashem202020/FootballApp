//
//  TeamView.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import SnapKit

class TeamView: NiblessView {
    // MARK: - Properties
    // MARK: - Properties
    let tableView = UITableView().with {
        $0.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchTableViewCell")
        $0.backgroundColor = .clear
        $0.backgroundView = nil
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 600
        $0.separatorStyle = .none
        if #available(iOS 13.0, *) {
            $0.automaticallyAdjustsScrollIndicatorInsets = false
        }
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
        $0.tableFooterView = UIView()
    }
    let loadingIndicator = UIActivityIndicatorView().with {
        if #available(iOS 13.0, *) {
            $0.style = .large
        } else {
            $0.style = .whiteLarge
        }
        $0.hidesWhenStopped = true
        $0.color = .red
    }

    init() {
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
        styleView()
    }
    
    private func constructHierarchy() {
        addSubview(tableView)
        addSubview(loadingIndicator)

    }

    private func activateConstraints() {
        tableView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func styleView() {
        backgroundColor = .white
    }

}
