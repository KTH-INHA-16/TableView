//
//  FolderTableViewCell.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/13.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    @IBOutlet weak var folderTitleLabel: UILabel!
    @IBOutlet weak var folderMemoCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
