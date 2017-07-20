//
//  TaskDelay.swift
//  Swift-IJKPlayer
//
//  Created by 李利锋 on 2017/7/20.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import Foundation

typealias Task = (_ cancel : Bool) -> Void

//var delaytask:Task?


func leefeng_delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    

    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func leefeng_cancel(_ task: Task?) {
    task?(true)
}
