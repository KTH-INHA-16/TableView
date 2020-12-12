//
//  MemoTableViewCell.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/08.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addtionLabel: UILabel!
    @IBOutlet weak var finishSwitch: UISwitch!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
