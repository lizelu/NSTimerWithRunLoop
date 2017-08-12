//
//  ViewController.swift
//  NSTimerWithRunLoop
//
//  Created by Mr.LuDashi on 2017/8/7.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var firstTableView: UITableView!
    @IBOutlet var secondTableView: UITableView!
    @IBOutlet var thirdTableView: UITableView!
    @IBOutlet var fourthTableView: UITableView!
    
    @IBOutlet var displayLinkTableView: UITableView!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableDelegate(tableView: firstTableView)
        configTableDelegate(tableView: secondTableView)
        configTableDelegate(tableView: thirdTableView)
        configTableDelegate(tableView: fourthTableView)
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
        
        var reuserId = "TimerDefaultModeCell"
        
        if tableView === secondTableView {
            reuserId = "TimerCommonModesCell"
        } else if tableView === thirdTableView {
            reuserId = "TimerSubThreadCell"
        } else if tableView === fourthTableView {
            reuserId = "DispatchSourceTimerCell"
        } else if tableView === displayLinkTableView {
            reuserId = "DisplayLinkCell"
        }
        
        return tableView.dequeueReusableCell(withIdentifier: reuserId)!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
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

