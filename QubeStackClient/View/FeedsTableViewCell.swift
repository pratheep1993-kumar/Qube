//
//  FeedsTableViewCell.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import UIKit
import TagListView


class FeedsTableViewCell: UITableViewCell,TagListViewDelegate{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var upCount: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tagList.delegate = self
        tagList.textFont = UIFont.systemFont(ofSize: 12)
        tagList.alignment = .left // possible values are [.leading, .trailing, .left, .center, .right]
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
