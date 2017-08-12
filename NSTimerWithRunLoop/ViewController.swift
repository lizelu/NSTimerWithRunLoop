//
//  ViewController.swift
//  NSTimerWithRunLoop
//
//  Created by Mr.LuDashi on 2017/8/7.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

enum TimerTableViewType: Int {
    case TimerDefaultModeTableViewType = 0
    case TimerCommonModesTableViewType
    case TimerSubThreadTableViewType
    case DispatchSourceTimerTableViewType
    case DisplayLinkTableViewType
    
    var cellReuseId: String {
        get {
            switch self {
            case .TimerDefaultModeTableViewType:
                return "TimerDefaultModeCell"
                
            case .TimerCommonModesTableViewType:
                return "TimerCommonModesCell"
                
            case .TimerSubThreadTableViewType:
                return "TimerSubThreadCell"
                
            case .DispatchSourceTimerTableViewType:
                return "DispatchSourceTimerCell"
                
            case .DisplayLinkTableViewType:
                return "DisplayLinkCell"
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var timerDefaultModeTableView: UITableView!
    @IBOutlet var timerCommonModesTableView: UITableView!
    @IBOutlet var timerSubThreadTableView: UITableView!
    @IBOutlet var dispatchSourceTimerTableView: UITableView!
    
    @IBOutlet var displayLinkTableView: UITableView!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableDelegate(tableView: timerDefaultModeTableView)
        configTableDelegate(tableView: timerCommonModesTableView)
        configTableDelegate(tableView: timerSubThreadTableView)
        configTableDelegate(tableView: dispatchSourceTimerTableView)
        configTableDelegate(tableView: displayLinkTableView)
        print("viewDidLoad -- \(String(describing: RunLoop.current.currentMode!))\n\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear -- \(String(describing: RunLoop.current.currentMode!))\n\n")
    }
    
    //MARK: - Private Method
    func configTableDelegate(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Event Response
    @IBAction func tapShowCurrentModeButton(_ sender: UIButton) {
        print("tapShowCurrentModeButton -- \(String(describing: RunLoop.current.currentMode!))\n\n")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewType = TimerTableViewType.init(rawValue: tableView.tag)
        return tableView.dequeueReusableCell(withIdentifier: (tableViewType?.cellReuseId)!)!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll -- \(String(describing: RunLoop.current.currentMode!))")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("\n\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

