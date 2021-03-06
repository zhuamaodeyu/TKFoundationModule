//
//  Date+Ext.swift
//  Pods-TKBaseModule_Example
//
//  Created by 聂子 on 2018/11/11.
//

import Foundation

extension Date: NamespaceWrappable {}

/// Date

extension TypeWrapperProtocol where WrappedType == Date {
    /// 是否是当年
    ///
    /// - Returns: true 是 false 不是
    public func isCurrentYear() -> Bool {
         let calendar = Calendar.current
        let selfYear = calendar.component(.year, from: self.wrappedValue)
        let newYear = calendar.component(.year, from: Date())
        return selfYear == newYear
    }
    
    /// 明天
    ///
    /// - Returns: true 是  false 不是
    public func tomorrow() -> Bool {
//        let fmt = DateFormatter()
//        fmt.dateFormat = "yyyy-MM-dd"
//        let string = fmt.string(from: self.wrappedValue)
//        let date = fmt.date(from: string)
//        if date == nil {
//            debugPrint(message: "============self to formatter fail")
//            return false
//        }
//        let newString = fmt.string(from: Date())
//        let newDate = fmt.date(from: newString)
//        if newDate == nil
//        {
//            debugPrint(message: "=======Date() now to formatter fail")
//            return false
//        }
        
        // 比较时差
        let calendar = Calendar.current
        let unit = Set(arrayLiteral: Calendar.Component.year , Calendar.Component.month, Calendar.Component.day)
        let cmps = calendar.dateComponents(unit, from: self.wrappedValue, to: Date())
        return cmps.year == 0 && cmps.month == 0 && cmps.day == -1
        
    }
    
    /// 是否是昨天
    ///
    /// - Returns: true 是 false 不是
    public func yesterday() -> Bool {
        // 转换为相同格式
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let string = fmt.string(from: self.wrappedValue)
        let date = fmt.date(from: string)
        if date == nil {
            debugPrint(message: "============self to formatter fail")
            return false
        }
        let newString = fmt.string(from: Date())
        let newDate = fmt.date(from: newString)
        if newDate == nil
        {
            debugPrint(message: "=======Date() now to formatter fail")
            return false
        }
        
        // 比较时差
        let calendar = Calendar.current
        let unit = Set(arrayLiteral: Calendar.Component.year , Calendar.Component.month, Calendar.Component.day)
        let cmps = calendar.dateComponents(unit, from: date!, to: newDate!)
        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1
    }
    
    /// 是否是今天
    ///
    /// - Returns: true 是 false 否
    public func today() -> Bool {
        let calendar = Calendar.current
        let unit = Set(arrayLiteral: Calendar.Component.year , Calendar.Component.month, Calendar.Component.day)
        let cmps = calendar.dateComponents(unit, from: self.wrappedValue )
        let newCmps = calendar.dateComponents(unit, from: Date())
        return cmps.year == newCmps.year && cmps.month == newCmps.month && cmps.day == newCmps.day
    }
    
    
    /// 是否是同一周
    ///
    /// - Returns: true 是 false 不是
    public func currentWeek(date: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let unit = Set(arrayLiteral: Calendar.Component.year , Calendar.Component.month, Calendar.Component.day)
        let cmps = calendar.dateComponents(unit, from: self.wrappedValue , to: Date())
        return cmps.year ?? 0 == 0 && cmps.month ?? 0  == 0 && cmps.day ?? 0 <= 7
    }
    
    /// 是否是当月
    ///
    /// - Returns: true 是 false 不是
    public func currentMonth() -> Bool {
        let calendar = Calendar.current
        let unit = Set(arrayLiteral: Calendar.Component.year , Calendar.Component.month)
        let cmps = calendar.dateComponents(unit, from: self.wrappedValue )
        let newCmps = calendar.dateComponents(unit, from: Date())
        return cmps.year == newCmps.year && cmps.month == newCmps.month
    }
    
    
    
    /// 星期几
    ///
    /// - Returns: 0 获取错误
    public func weekDay(timeZone:TimeZone = TimeZone.current) -> Int {
        let weekdays = [7,1,2,3,4,5,6]
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let cmp =  calendar.dateComponents(Set(arrayLiteral: .weekday), from: self.wrappedValue)
        return weekdays.index(of: cmp.weekday ?? 0) ?? 0
    }
    
    
    
    /// 相差
    /// 仅支持 年 月 日 时 分 秒
    /// - Returns: 天数
    public func distance(type: Calendar.Component) -> Int {
     
        return 0
    }
    
    
    
    public func compare(date: Date = Date()) -> Int {
        let time = self.wrappedValue.timeIntervalSince(date)
        if time > 0 {
            return 1
        }
        if time == 0 {
            return 0
        }
        if time < 0 {
            return -1
        }
        return 0
    }
    
    
    /// 时间格式
    ///
    /// - Returns: 时间格式结果字符串
    public static func description() -> String {
        return "G: 公元时代，例如AD公元 \n yy: 年的后2位 \n yyyy: 完整年 \n MM: 月，显示为1-12 \n MMM: 月，显示为英文月份简写,如 Jan \n MMMM: 月，显示为英文月份全称，如 Janualy \n dd: 日，2位数表示，如02 \n d: 日，1-2位显示，如 2\n EEE: 简写星期几，如Sun \n EEEE: 全写星期几，如Sunday \n aa: 上下午，AM/PM \n H: 时，24小时制，0-23\n K：时，12小时制，0-11 \n  m: 分，1-2位\n mm: 分，2位 \n s: 秒，1-2位 \n ss: 秒，2位 \n S: 毫秒 \n"
    }
}




public enum DateFormatType {
    case YMD  // yyyy-mm-dd
    case MD // mm-dd
    case YMDTime // yyyy-MM-dd HH:mm:ss
    case Time   // HH:mm:ss
    case MDTime // MM-dd hh:mm
    case TimeZone // yyyy-MM-dd 'T' HH:mm:ssZ
}
extension TypeWrapperProtocol where WrappedType == Date {
    
    /// date ---> string
    ///
    /// - Parameter type: type
    /// - Returns: string
    public func string(with type:DateFormatType) -> String? {
        let dateFormatter = DateFormatter.init()
        switch type {
        case .YMD:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        case .MD:
            dateFormatter.dateFormat = "MM-dd"
        case .YMDTime:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case .Time:
            dateFormatter.dateFormat = "HH:mm:ss"
        case .MDTime:
            dateFormatter.dateFormat = "MM-dd hh:mm"
        case .TimeZone:
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return dateFormatter.string(from: self.wrappedValue)
    }

}

//G: 公元时代，例如AD公元
//yy: 年的后2位
//yyyy: 完整年
//MM: 月，显示为1-12
//MMM: 月，显示为英文月份简写,如 Jan
//MMMM: 月，显示为英文月份全称，如 Janualy
//dd: 日，2位数表示，如02
//d: 日，1-2位显示，如 2
//EEE: 简写星期几，如Sun
//EEEE: 全写星期几，如Sunday
//aa: 上下午，AM/PM
//H: 时，24小时制，0-23
//K：时，12小时制，0-11
//m: 分，1-2位
//mm: 分，2位
//s: 秒，1-2位
//ss: 秒，2位
//S: 毫秒
//

