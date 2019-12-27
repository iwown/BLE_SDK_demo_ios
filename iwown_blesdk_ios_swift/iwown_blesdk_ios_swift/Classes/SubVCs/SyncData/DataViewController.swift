//
//  DataViewController.swift
//  iwown_blesdk_ios_swift
//
//  Created by A$CE on 2018/6/5.
//  Copyright © 2018年 A$CE. All rights reserved.
//

import UIKit
import BLEMidAutumn

class DataViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: BLE_SYSCDATA_GETDATASCORE), object: nil, queue: nil) { (notification) in
            
            self.loadData()
            self._tableView?.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func initParam() {
        _dataSource = NSMutableArray.init(array: [[],[],[]])
        BLEShareInstance.bleSolstice().getDataStoreDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void {
        if (BLEShareInstance.sharedInstance.dateArr?.count)! > 0 {
            _dataSource?.replaceObject(at: 0, with: BLEShareInstance.sharedInstance.dateArr as Any)
        }
        if (BLEShareInstance.sharedInstance.dInfo61Arr?.count)! > 0 {
            _dataSource?.replaceObject(at: 0, with: BLEShareInstance.sharedInstance.dInfo61Arr as Any)
        }
        if (BLEShareInstance.sharedInstance.dInfo62Arr?.count)! > 0 {
            _dataSource?.replaceObject(at: 0, with: BLEShareInstance.sharedInstance.dInfo62Arr as Any)
        }
    }
}

extension DataViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let arr:NSArray = _dataSource![indexPath.section] as! NSArray
        
        if arr.count > 0 {
            let tObj = arr[indexPath.row]
            if tObj is NSDate {
                cell.textLabel?.text = "\(tObj)"
            }else if (tObj is DDInfo){
                cell.textLabel?.text = "\((tObj as! DDInfo).date)"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_dataSource![section] as! NSArray).count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (_dataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerRect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:55)
        let vi = UIView.init(frame: headerRect)
        vi.backgroundColor = UIColor.lightGray
        
        let labRect:CGRect = CGRect(x:20, y:0, width:200, height:55)
        let lab = UILabel.init(frame: labRect)
        var labText = "";
        switch section {
        case 0:
            labText = "Hybrid Health Data"
            break;
        case 1:
            labText = "Normal Data 0x61"
            break;
        case 2:
            labText = "GNSS Data 0x62"
            break;
        default:
            break;
        }
        lab.text = labText
        
        vi.addSubview(lab)
        return vi
    }
}


