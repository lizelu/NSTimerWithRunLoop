//
//  ThirdTableViewCell.swift
//  NSTimerWithRunLoop
//
//  Created by Mr.LuDashi on 2017/8/8.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let queue: DispatchQueue = DispatchQueue.global()
        let source = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue)
        
        let timer = UInt64(1) * NSEC_PER_SEC
        source.scheduleRepeating(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(timer)), interval: DispatchTimeInterval.seconds(Int(1)), leeway: DispatchTimeInterval.seconds(0))
        
        let timeout = 1    //倒计时时间
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        //设置要处理的事件, 在我们上面创建的queue队列中进行执行
        source.setEventHandler {
            if(timeout < 0) {
                source.cancel()
            }
            
            DispatchQueue.main.async {
                self.timeLabel.text = "\(dateFormatter.string(from: Date()))"
            }
        }
        
        source.resume()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
