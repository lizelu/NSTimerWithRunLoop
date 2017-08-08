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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableDelegate(tableView: firstTableView)
        configTableDelegate(tableView: secondTableView)
        configTableDelegate(tableView: thirdTableView)
        configTableDelegate(tableView: fourthTableView)
    }
    
    func configTableDelegate(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuserId = "SecondTableViewCell"
        if tableView === firstTableView {
            reuserId = "FirstTableViewCell"
        } else if tableView === thirdTableView {
            reuserId = "ThirdTableViewCell"
        } else if tableView === fourthTableView {
            reuserId = "ForthTableViewCell"
        }
        
        return tableView.dequeueReusableCell(withIdentifier: reuserId)!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

