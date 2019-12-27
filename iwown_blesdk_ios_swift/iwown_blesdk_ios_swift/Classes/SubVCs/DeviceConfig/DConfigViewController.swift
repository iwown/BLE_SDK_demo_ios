//
//  DConfigViewController.swift
//  iwown_blesdk_ios_swift
//
//  Created by A$CE on 2018/6/5.
//  Copyright © 2018年 A$CE. All rights reserved.
//

import UIKit
import BLEMidAutumn

class DConfigViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initParam() {
        super.initParam()
        let arr = ["Reboot","Unbind","Upgrade","ConnectState"];
        _dataSource?.addObjects(from: arr)
    }
    
    override func initUI() {
        super.initUI()
        self.title = "Device Config"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DConfigViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = _dataSource?[indexPath.row] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        switch indexPath.row {
        case 0:
            BLEShareInstance.bleSolstice().rebootDevice()
            break
        case 1:
            BLEShareInstance.sharedInstance._bleAutumn?.unbind()
            break
        case 2:
            BLEShareInstance.bleSolstice().deviceUpgrade()
            break
        case 3:
            BLEShareInstance.bleSolstice().getConnectionStatus()
            break
        default:
            break
        }
    }
}
