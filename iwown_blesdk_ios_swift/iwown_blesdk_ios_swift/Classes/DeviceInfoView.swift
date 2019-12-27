//
//  DeviceInfoView.swift
//  IW_BLESDK_swift
//
//  Created by 曹凯 on 2017/1/21.
//  Copyright © 2017年 Zeroner. All rights reserved.
//

import UIKit
import BLEMidAutumn

class DeviceInfoView: UIView {

    var nameLab : UILabel!
    var batteryLab : UILabel!
    var versionLab : UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        let labWidth:CGFloat ,labHeight:CGFloat
        labWidth = (rect.width/3.0)
        labHeight = (rect.height)
        
        let rectLeft:CGRect = CGRect(x:0, y:0, width:labWidth, height:labHeight)
        nameLab = UILabel.init(frame: rectLeft)
        nameLab.text = "name"
        nameLab.textAlignment = NSTextAlignment.right;
        nameLab.textColor = UIColor.gray
        nameLab.numberOfLines = 0;
        
        let rectCenter:CGRect = CGRect(x:labWidth, y:0, width:labWidth, height:labHeight)
        batteryLab = UILabel.init(frame: rectCenter)
        batteryLab.text = "battery"
        batteryLab.textAlignment = NSTextAlignment.center;
        batteryLab.textColor = UIColor.red
        batteryLab.numberOfLines = 0;

        let rectRight:CGRect = CGRect(x:labWidth*2, y:0, width:labWidth, height:labHeight)
        versionLab = UILabel.init(frame: rectRight)
        versionLab.text = "version"
        versionLab.textAlignment = NSTextAlignment.left;
        versionLab.textColor = UIColor.blue
        versionLab.numberOfLines = 0;

        self.addSubview(nameLab)
        self.addSubview(batteryLab)
        self.addSubview(versionLab)
    }
    
    func reloadView(_ deviceInfo: ZRDeviceInfo ,_ name: String) {
        
        versionLab.text = "Ver:" + deviceInfo.version
        batteryLab.text = "Bat:\(deviceInfo.batLevel)"
        nameLab.text = "Name:" + name
    }
}
