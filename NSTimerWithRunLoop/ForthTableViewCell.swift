//
//  ForthTableViewCell.swift
//  NSTimerWithRunLoop
//
//  Created by Mr.LuDashi on 2017/8/8.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class ForthTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.global().async {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                DispatchQueue.main.async {
                    self.timeLabel.text = "\(dateFormatter.string(from: Date()))"
                }
            }
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
            RunLoop.current.run()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
