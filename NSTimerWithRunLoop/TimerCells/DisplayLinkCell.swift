//
//  DisplayLinkCell.swift
//  NSTimerWithRunLoop
//
//  Created by ZeluLi on 2017/8/12.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class DisplayLinkCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let displayLink = CADisplayLink(target: self, selector: #selector(self.update))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        self.timeLabel.text = "\(dateFormatter.string(from: Date()))"
    }

}
