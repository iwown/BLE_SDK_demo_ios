//
//  BaseViewController.swift
//  iwown_blesdk_ios_swift
//
//  Created by A$CE on 2018/6/5.
//  Copyright © 2018年 A$CE. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var _tableView:UITableView? = nil
    var _dataSource:NSMutableArray? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initParam()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    func initParam() -> Void {
        _dataSource = NSMutableArray.init(capacity: 0)
    }
    
    func initUI() -> Void {
        
        let rect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT)
        _tableView = UITableView.init(frame: rect, style: UITableView.Style.plain)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        self.view.addSubview(_tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID:String = "cell"
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if(cell == nil){
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseID)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSource!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
