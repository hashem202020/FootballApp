//
//  TeamHeaderView.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import RxSwift
import Kingfisher

public final class TeamHeaderView: NiblessView {

    //MARK: - Properties
    
    private(set) lazy var teamImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    public private(set) lazy var teamNameLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.8
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return $0
    }(UILabel())

    private lazy var contentStackView: UIStackView = {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.spacing = 12
        $0.addArrangedSubview(teamImage)
        $0.addArrangedSubview(teamNameLabel)
        return $0
    }(UIStackView())

    private let disposeBag = DisposeBag()

    // MARK: - Methods
    
    public init(teamImageObservable: Observable<String>,
                teamNameObservable: Observable<String>) {
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
        
        teamImageObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.teamImage.kf.setImage(with: $0.isEmpty ? nil : URL(string: $0), placeholder: UIImage(named: "doc"))
            }.disposed(by: disposeBag)

        teamNameObservable
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.teamNameLabel.text = $0
            }.disposed(by: disposeBag)
    }
    private func constructHierarchy() {
        addSubview(contentStackView)
    }
    
    private func activateConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        teamImage.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
    }

}
