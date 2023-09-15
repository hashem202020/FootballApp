//
//  LeaguesTableViewCell.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import UIKit
import Kingfisher

final public class LeaguesTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) public weak var leagueImage: UIImageView!
    
    @IBOutlet private(set) public weak var titleLabel: UILabel!
    
    @IBOutlet private(set) public weak var teamsLabel: UILabel! {
        didSet {
            if #available(iOS 13.0, *) {
                teamsLabel.textColor = UIColor(named: "GrayText")
            } else {
                teamsLabel.textColor = .gray
            }
        }
    }
    @IBOutlet private(set) public weak var gamesLabel: UILabel! {
        didSet {
            if #available(iOS 13.0, *) {
                gamesLabel.textColor = UIColor(named: "GrayText")
            } else {
                gamesLabel.textColor = .gray
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

    public func configure(with item: LeaguesPresentable) {
        leagueImage.kf.setImage(with: item.thumbnail.isEmpty ? nil : URL(string: item.thumbnail), placeholder: UIImage(named: "Ball"))
        titleLabel.text = item.title
        teamsLabel.text = item.teamsCount
        gamesLabel.text = item.gamesCount
    }
}
