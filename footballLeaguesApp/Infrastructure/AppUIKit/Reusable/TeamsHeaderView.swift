//
//  TeamsHeaderView.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import RxSwift
import Kingfisher

public final class TeamsHeaderView: NiblessView {
    
    //MARK: - Properties
    
    private(set) lazy var leagueImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "League")
        return $0
    }(UIImageView())

    public private(set) lazy var titleLabel: UILabel = {
        $0.textAlignment = .natural
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.8
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return $0
    }(UILabel())
    
    private(set) lazy var ballImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "Ball")
        return $0
    }(UIImageView())

    public private(set) lazy var teamLabel: UILabel = {
        $0.textAlignment = .natural
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.8
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if #available(iOS 11.0, *) {
            $0.textColor = UIColor(named: "GrayText")
        } else {
            $0.textColor = .gray
        }
        $0.text = "teams"
        return $0
    }(UILabel())
    
    private lazy var teamStackView: UIStackView = {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
        $0.addArrangedSubview(ballImage)
        $0.addArrangedSubview(teamLabel)
        return $0
    }(UIStackView())

    private(set) lazy var whistleImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "whistle")
        return $0
    }(UIImageView())

    public private(set) lazy var gamesLabel: UILabel = {
        $0.textAlignment = .natural
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.8
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if #available(iOS 11.0, *) {
            $0.textColor = UIColor(named: "GrayText")
        } else {
            $0.textColor = .gray
        }
        $0.text = "games"
        return $0
    }(UILabel())
    
    private lazy var whistleStackView: UIStackView = {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
        $0.addArrangedSubview(whistleImage)
        $0.addArrangedSubview(gamesLabel)
        return $0
    }(UIStackView())

    private lazy var teamsAndGamesStackView: UIStackView = {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 20
        $0.addArrangedSubview(teamStackView)
        $0.addArrangedSubview(whistleStackView)
        return $0
    }(UIStackView())

    private lazy var detailsStackView: UIStackView = {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.spacing = 10
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(teamsAndGamesStackView)
        return $0
    }(UIStackView())

    private lazy var contentStack: UIStackView = {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 20
        $0.addArrangedSubview(leagueImage)
        $0.addArrangedSubview(detailsStackView)
        return $0
    }(UIStackView())

    private let disposeBag = DisposeBag()

    // MARK: - Methods
    
    public init(leagueImageObservable: Observable<String>,
                titleObservable: Observable<String>,
                gamesObservable: Observable<String>,
                teamsObservable: Observable<String>) {
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
        styleView()

        leagueImageObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.leagueImage.kf.setImage(with: $0.isEmpty ? nil : URL(string: $0), placeholder: UIImage(named: "doc"))
            }.disposed(by: disposeBag)

        titleObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.titleLabel.text = $0
            }.disposed(by: disposeBag)
        
        gamesObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.gamesLabel.text = $0
            }.disposed(by: disposeBag)
        
        teamsObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.teamLabel.text = $0
            }.disposed(by: disposeBag)

        
    }
    private func constructHierarchy() {
        addSubview(contentStack)

    }
    
    private func activateConstraints() {
        contentStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        leagueImage.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        ballImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
        whistleImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }

    }
    
    private func styleView() {
    }

}
