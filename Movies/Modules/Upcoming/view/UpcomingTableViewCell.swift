//
//  UpcomingTableViewCell.swift
//  Movies
//
//  Created by aya on 18/09/2024.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var upcomingImageView: UIImageView!
    
    @IBOutlet weak var upcomingLable: UILabel!
    
    
    @IBOutlet weak var upcomingButton: UIButton!
    
    
    
    @IBAction func upcomingButton(_ sender: UIButton) {
    }
    
    public func configure(with model: TitleViewModel) {
        
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_path ?? "_")") else {return}
        upcomingImageView.sd_setImage(with: url,completed: nil)
        
        upcomingLable.text = model.original_title
    }
    
    static let identifier = "UpcomingTableViewCell"
    
}
