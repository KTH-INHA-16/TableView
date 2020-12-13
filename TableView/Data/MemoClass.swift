//
//  MemoClass.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/09.
//

import UIKit

class MemoClass{
    var isPined: Bool = false
    var font: CGFloat = CGFloat(12.0)
    var time: Date = Date()
    var year: String
    var month: String
    var day: String
    var hour: String
    var min: String
    var sec: String
    var able: Bool?
    var password: String = ""
    var lock: Bool = false
    var title:String? = "새로운 메모"
    var subTitle:String? = "추가된 내용 없음"
    var contents:String? = ""
    
    var total: Int {
        guard let num = Int(year + month + day + hour + min + sec) else {
            return 0
        }
        return  num
    }
    
    var compare: Int {
        guard let num = Int(year + month + day) else {
            return 0
        }
        return num
    }
    
    init(year:String,month:String,day:String,hour:String,min:String,sec:String) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
    }
}

extension MemoClass: Comparable, Equatable {
    static func < (lhs: MemoClass, rhs: MemoClass) -> Bool {
        return lhs.time > rhs.time
    }
    
    static func > (lhs: MemoClass, rhs: MemoClass) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func == (lhs: MemoClass, rhs: MemoClass) -> Bool {
        return lhs.time == rhs.time
    }
}
