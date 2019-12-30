//
//  ViewController.swift
//  IW_BLESDK_swift
//
//  Created by 曹凯 on 2017/1/19.
//  Copyright © 2017年 Zeroner. All rights reserved.
//

import UIKit
import BLEMidAutumn

class ViewController: UIViewController {
    
    var tableView : UITableView? = nil
    var deviceView : DeviceInfoView!
    var bleInstance :BLEShareInstance!
    let arrS = ["DEVICE CONFIG","HWOption","SET&READ","DATA SYNC","MESSAGE"];
    let arr = [["Device Info","DEVICE CONFIG","Dev tmp"],
               ["HWOption","Schedule&Clock","Custom Option","Sedentary"],
               ["Date Time","More"],
               ["Summary Data","Sysc More"],
               ["Push String","Black List"]
              ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initParam()
        self.initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initParam() {
        bleInstance = BLEShareInstance.sharedInstance
        bleInstance._delegate = self
        self.title = "IWBLEDemo"
    }
    
    func initUI() {
        let itemLeft:UIBarButtonItem = UIBarButtonItem.init(title: "BIND", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.scanDevices))
        self.navigationItem.leftBarButtonItem = itemLeft
        
        let rect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT)
        tableView = UITableView.init(frame: rect, style: UITableView.Style.plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        let headerRect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:55)
        deviceView = DeviceInfoView.init(frame: headerRect)
        deviceView.backgroundColor = UIColor.white
        tableView?.tableHeaderView = deviceView
    }
    
    @objc func scanDevices() {
        let dcVC:DCViewController = DCViewController.init()
        self.navigationController?.pushViewController(dcVC, animated: true)
    }
}

extension ViewController: BLEShareInstanceDelegate {
    
    func deviceInfoDidUpdate(_ info: ZRDeviceInfo, name: String) {
        DispatchQueue.main.async {
            self.deviceView.reloadView(info, name)
        }
    }
}

extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID:String = "cell"
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if(cell == nil){
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseID)
        }
        cell?.textLabel?.text=arr[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrS.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrS[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !BLEShareInstance.sharedInstance.isValid() {
            return
        }
        
        switch indexPath.section {
        case 0:
            self.selectCellAtZero(indexRow: indexPath.row)
            break
        case 1:
            self.selectCellAtOne(indexRow: indexPath.row)
            break
        case 2:
            self.selectCellAtTwo(indexRow: indexPath.row)
            break
        case 3:
            self.selectCellAtThere(indexRow: indexPath.row)
            break
        case 4:
            self.selectCellAtFour(indexRow: indexPath.row)
            break
        default:
            break
        }
    }
    
    func selectCellAtZero(indexRow : Int) {
        switch indexRow {
        case 0:
            BLEShareInstance.bleSolstice().readDeviceBattery()
            BLEShareInstance.bleSolstice().readDeviceInfo()
            break
        case 1:
            let vc = DConfigViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            break
        default:
            break
        }
    }
    
    func selectCellAtOne(indexRow : Int) {
        switch (indexRow) {
        case 0:
            let vc = HWOptionController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 1:
            let vc = ClockViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 2:
            let vc = CHOptionController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = SedentaryViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break;
        }
    }
    
    func selectCellAtTwo(indexRow : Int) {
        switch (indexRow) {
        case 0:
            BLEShareInstance.bleSolstice().syscTime(Date())
            break;
        case 1:
            let vc = MoreViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
            
        default:
            break;
        }
    }
    
    func selectCellAtThere(indexRow : Int) {
        switch (indexRow) {
        case 0:
            BLEShareInstance.bleSolstice().startSpecialData(SD_TYPE.DATA_SUMMARY)
            break;
        case 1:
            let vc = DataViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 2:
            
            break;
        default:
            break;
        }
    }
    
    func selectCellAtFour(indexRow : Int) {
        switch (indexRow) {
        case 0:
            BLEShareInstance.bleSolstice().pushStr("Hello World !!!")
            break;
        case 1:
            let vc = BlackListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
            
        default:
            break;
        }
    }
}
