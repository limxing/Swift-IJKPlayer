//
//  PlayControButton.swift
//  BeiVideo
//
//  Created by 李利锋 on 2017/7/19.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit

class PlayControButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var showPlayView:(()->())?
    
    var beginTouch:CGPoint?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let moveTouch = event?.touches(for: self)?.first?.location(in: self)
        print("x:\(moveTouch?.x);y:\(moveTouch?.y)")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginTouch = event?.touches(for: self)?.first?.location(in: self)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let endTouch = event?.touches(for: self)?.first?.location(in: self)
        if (beginTouch?.equalTo(endTouch!))! {
             showPlayView?()
        }
        
    }

}
