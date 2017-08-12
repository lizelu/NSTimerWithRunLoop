//
//  FirstTableViewCell.swift
//  NSTimerWithRunLoop
//
//  Created by Mr.LuDashi on 2017/8/7.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class TimerDefaultModeCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            self.timeLabel.text = "\(dateFormatter.string(from: Date()))"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
