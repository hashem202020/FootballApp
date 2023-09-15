//
//  MatchTableViewCell.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import Kingfisher

final public class MatchTableViewCell: UITableViewCell {

    @IBOutlet private(set) public weak var homeTeamNameLabel: UILabel!
    @IBOutlet private(set) public weak var awayTeamNameLabel: UILabel!
    @IBOutlet private(set) public weak var homeScoreLabel: UILabel!
    @IBOutlet private(set) public weak var awayScoreLabel: UILabel!
    @IBOutlet private(set) public weak var homeLogo: UIImageView!
    @IBOutlet private(set) public weak var awayLogo: UIImageView!
    
    @IBOutlet private(set) public weak var statusLabel: UILabel! {
        didSet {
            if #available(iOS 13.0, *) {
                statusLabel.textColor = UIColor(named: "GrayText")
            } else {
                statusLabel.textColor = .gray
            }
        }
    }
    
    @IBOutlet private(set) weak var spacer: UIView! {
        didSet {
            if #available(iOS 13.0, *) {
                spacer.backgroundColor = UIColor(named: "GraySeprator")
            } else {
                spacer.backgroundColor = .gray
            }
        }
    }
    
    public func configure(with item: MatchPresentable) {
        homeTeamNameLabel.text = item.homeTeam
        awayTeamNameLabel.text = item.awayTeam
        homeScoreLabel.text = item.homeScore
        awayScoreLabel.text = item.awayScore
        statusLabel.text = item.status
        homeLogo.kf.setImage(with: item.homeLogo.isEmpty ? nil : URL(string: item.homeLogo), placeholder: UIImage(named: "whistle"))
        awayLogo.kf.setImage(with: item.awayLogo.isEmpty ? nil : URL(string: item.awayLogo), placeholder: UIImage(named: "whistle"))

    }

}
