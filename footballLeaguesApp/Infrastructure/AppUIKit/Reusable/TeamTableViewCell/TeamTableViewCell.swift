//
//  TeamTableViewCell.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 30/04/2022.
//

import UIKit
import Kingfisher

final public class TeamTableViewCell: UITableViewCell {

    @IBOutlet private(set) public weak var teamImage: UIImageView!
    @IBOutlet private(set) public weak var teamNameLabel: UILabel!
    @IBOutlet private(set) weak var spacer: UIView! {
        didSet {
            if #available(iOS 13.0, *) {
                spacer.backgroundColor = UIColor(named: "GraySeprator")
            } else {
                spacer.backgroundColor = .gray
            }

        }
    }

    public func configure(with item: TeamPresentable) {
        teamImage.kf.setImage(with: item.thumbnail.isEmpty ? nil : URL(string: item.thumbnail), placeholder: UIImage(named: "Ball"))
        teamNameLabel.text = item.name
    }

}
