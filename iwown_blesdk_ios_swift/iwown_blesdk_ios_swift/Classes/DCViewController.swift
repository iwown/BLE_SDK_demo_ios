//
//  DCViewController.swift
//  IW_BLESDK_swift
//
//  Created by 曹凯 on 2017/1/20.
//  Copyright © 2017年 Zeroner. All rights reserved.
//
enum ScanState {
    
    case scaning
    case scaned
    case null
}

import UIKit
import BLEMidAutumn

class DCViewController: UIViewController {
    
    var tableView : UITableView? = nil
    var scanBtn : UIButton? = nil
    
    var dataSource = [ZRBlePeripheral]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initParam()
        self.initUI()
    }
    
    func initParam() {
        self.title = "BIND"
        BLEShareInstance.sharedInstance._bleAutumn?.discoverDelegate = self
        BLEShareInstance.sharedInstance._bleAutumn?.connectDelegate = self
        self.scanDevice()
    }
    
    func initUI() {
        
        let rect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT)
        tableView = UITableView.init(frame: rect, style: UITableView.Style.plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        let headerRect:CGRect = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:50)
        scanBtn = UIButton.init(type: UIButton.ButtonType.custom)
        scanBtn?.frame = headerRect
        scanBtn?.setTitle("Start", for: UIControl.State.normal)
        scanBtn?.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        scanBtn?.setTitleColor(UIColor.lightGray, for: UIControl.State.highlighted)
        scanBtn?.addTarget(self, action: #selector(DCViewController.scanDevice), for: UIControl.Event.touchUpInside)
        tableView?.tableHeaderView = scanBtn
    }
    
    @objc func scanDevice() {
        BLEShareInstance.sharedInstance._bleAutumn?.startScan()

        print("new scan")
    }
}

extension DCViewController: BleDiscoverDelegate,BleConnectDelegate {
    func solsticeStopScan() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func solsticeDidDiscoverDevice(withMAC iwDevice: ZRBlePeripheral!) {
        if (iwDevice != nil) {
            print(iwDevice.deviceName)
            print(iwDevice.uuidString)
            if self.dataSource.filter({ el in el.uuidString == iwDevice.uuidString }).count == 0 {
                self.dataSource.append(iwDevice)
//                self.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }
    
    func solsticeDidConnectDevice(_ device: ZRBlePeripheral!) {
        if(device != nil) {
            print("conncetted \(device)" )
        }
        BLEShareInstance.sharedInstance._bleAutumn?.stopScan()
        BLEShareInstance.sharedInstance.startWithConnectedDevice(device: device)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DCViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID:String = "cell"
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if(cell == nil){
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseID)
        }
        cell?.textLabel?.text=self.dataSource[indexPath.row].deviceName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedDevice:ZRBlePeripheral = dataSource[indexPath.row]
        BLEShareInstance.sharedInstance._bleAutumn?.unbind()
        BLEShareInstance.sharedInstance._bleAutumn?.bindDevice(selectedDevice);
    }
}
