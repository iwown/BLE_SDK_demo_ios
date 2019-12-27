//
//  BLEShareInstance.swift
//  IW_BLESDK_swift
//
//  Created by 曹凯 on 2017/5/11.
//  Copyright © 2017年 Iwown. All rights reserved.
//

import UIKit
import BLEMidAutumn

protocol BLEShareInstanceDelegate{
    func deviceInfoDidUpdate(_ info: ZRDeviceInfo ,name:String);
}

class BLEShareInstance: NSObject {
    
    var _bleAutumn:BLEAutumn?
    var _solstice:BLESolstice?
    
    var dateArr:NSArray? = []
    var dInfo61Arr:NSArray? = []
    var dInfo62Arr:NSArray? = []

    static let sharedInstance: BLEShareInstance = {
        let instance = BLEShareInstance()
        
        instance._bleAutumn = BLEAutumn.midAutumn(BLEProtocol.any)
        return instance
    }()
    
    func startWithConnectedDevice(device : ZRBlePeripheral) -> Void {
        _name = device.deviceName
        _solstice = _bleAutumn?.solstice(withConnectedPeripheral: device)
        _bleAutumn?.registerSolsticeEquinox(self as BLEquinox)
    }
    
    static func bleSolstice() -> BLESolstice {
        return BLEShareInstance.sharedInstance._solstice!
    }
    
    func isValid() -> Bool {
        if _solstice == nil {
            print("Lose connection, Bind device at began.")
            return false
        }
        return true
    }
    
    var _delegate:BLEShareInstanceDelegate?
    var _deviceInfo:ZRDeviceInfo!
    var _name:String = ""
    
    
    func updateDataDate(zrDInfo : ZRDataInfo) -> Void {
        
        let dArr:NSMutableArray = NSMutableArray.init(capacity: 0)
        for dInfo in zrDInfo.ddInfos {
            let date = dInfo.date!
            dArr.add(date)
        }
        
        dateArr = dArr
    }
}

extension BLEShareInstance: BLEquinox {
    
    func bleLogPath() -> String! {
        let foldPath:String = NSHomeDirectory() + "/Documents"
        let logFilePath = foldPath + "/BLE.txt";
        return logFilePath;
    }
    
    func readRequiredInfoAfterConnect() {
        
    }
    
    func setBLEParameterAfterConnect() {
        
    }
    
    func readResponse(fromDevice response: ZRReadResponse!) {
        switch response.cmdResponse {
        case BLECmdResponse.CMD_RESPONSE_DEVICE_GET_INFORMATION,
             BLECmdResponse.CMD_RESPONSE_DEVICE_GET_BATTERY:
            _deviceInfo = response.data as! ZRDeviceInfo?
            _delegate?.deviceInfoDidUpdate(_deviceInfo, name: _name)
            break
        default:
            break
        }
    }
    
    func updateNormalHealthData(_ zrhData: ZRHealthData!) {
        
    }
    
    func updateNormalHealthDataInfo(_ zrDInfo: ZRDataInfo!) {
        
        let dType:ZRDIType = ZRDIType(rawValue: ZRDIType.RawValue(zrDInfo.dataType))
        switch dType {
        case ZRDITypeNormalHealth:
            dInfo61Arr = zrDInfo.ddInfos! as NSArray
            break
        case ZRDITypeGNSSData:
            dInfo62Arr = zrDInfo.ddInfos! as NSArray
            break
        case ZRDITypeECGHealth:
            
            break
        case ZRDITypeHbridHealth,ZRDITypeNormalData:
            self.updateDataDate(zrDInfo: zrDInfo)
            break
            
        default:
            break
        }
        
        
        
        let queue = DispatchQueue(label: "BLE_SYSCDATA_GETDATASCORE")
        queue.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLE_SYSCDATA_GETDATASCORE), object: nil)
        }
    }
    
}

