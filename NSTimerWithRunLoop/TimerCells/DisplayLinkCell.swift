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
    var currentTime = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.global().async {
            let displayLink = CADisplayLink(target: self, selector: #selector(self.update))
            displayLink.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
            RunLoop.current.run()
        }
    }

    func update() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = "\(dateFormatter.string(from: Date()))"
        
        if time != currentTime {
            currentTime = time
            DispatchQueue.main.async {
                self.timeLabel.text = self.currentTime
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
