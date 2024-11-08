//
//  UpcomingSrackTableViewCell.swift
//  Movies
//
//  Created by aya on 18/09/2024.
//

import UIKit

class UpcomingSrackTableViewCell: UITableViewCell {

 
    @IBOutlet weak var upcomingStackImage: UIImageView!
    
    @IBOutlet weak var upcomingStackLabel: UILabel!
    
    
    public func configure(with model: TitleViewModel) {
        
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_path ?? "_")") else {return}
        upcomingStackImage.sd_setImage(with: url,completed: nil)
        
        upcomingStackLabel.text = model.original_title
    }
    
    static let identifier = "UpcomingSrackTableViewCell"
    
    
}
