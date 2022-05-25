//
//  YYTimer.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import Foundation

public extension Int {
    static let infinity = -1
    
    /// <= .infinity表示执行无限次
    var isInfinity: Bool {
        return self <= .infinity
    }
}

public extension YYTimer {
    typealias TimesLeft = Int
    typealias Handler = (YYTimer, TimesLeft) -> Void
    
    /// 立即执行
    static func fire(times: Int = .infinity,
                     interval: DispatchTimeInterval,
                     queue: DispatchQueue = .main,
                     handler: @escaping Handler ) -> YYTimer {
        return YYTimer(interval: interval, mode: .times(times), fireNow: true, queue: queue, handler: handler).start()
    }
    
    /// 间隔interval后执行
    static func schedule(times: Int = .infinity,
                         interval: DispatchTimeInterval,
                         queue: DispatchQueue = .main ,
                         handler: @escaping Handler ) -> YYTimer {
        return YYTimer(interval: interval, mode: .times(times), fireNow: false, queue: queue, handler: handler).start()
    }
}

/// gcd Timer，不会强引用
public class YYTimer {
    public var timesLeft: Int {
        return mode.times - runTimes
    }
    
    private let timer: DispatchSourceTimer
    private let mode: Mode
    private let handler: Handler
    
    private var isRunning = false
    private var runTimes = 0
    
    public init(interval: DispatchTimeInterval,
                mode: Mode = .times(1),
                fireNow: Bool = false,
                queue: DispatchQueue = .main,
                handler: @escaping Handler) {
        self.mode = mode
        self.handler = handler
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler { [weak self] in
            self?.fire()
        }
        
        var statTime = DispatchTime.now()
        if !fireNow {
            statTime = statTime + interval
        }
        
        //		- parameter: deadline 计时器最迟开始时间;
        //		- parameter: repeating 时间间隔;
        //		- parameter: leeway 容忍时间;
        timer.schedule(deadline: statTime, repeating: interval, leeway: .seconds(0))
    }
    
    deinit {
        ///想关闭一个执行了suspend()操作的计时器, 需要先执行resume(), 再执行cancel(), 最后置nil.
        //		// 崩溃一:
        //		gcdTimer?.suspend()
        //		gcdTimer = nil
        //
        //		// 崩溃二:
        //		gcdTimer?.suspend()
        //		gcdTimer?.cancel()
        //		gcdTimer = nil
        if !isRunning {
            timer.resume()
        }
    }
}

public extension YYTimer {
    @discardableResult
    func start(after: Double = 0) -> YYTimer {
        if !isRunning {
            timer.resume()
            isRunning = true
        }
        
        return self
    }
    
    @discardableResult
    func pause() -> YYTimer {
        if isRunning {
            timer.suspend()
            isRunning = false
        }
        
        return self
    }
    
    @discardableResult
    func reStart(after: Double = 0) -> YYTimer {
        pause()
        runTimes = 0
        
        return start(after: after)
    }
}

private extension YYTimer {
    @discardableResult
    func fire() -> YYTimer {
        runTimes += 1
        handler(self, timesLeft)
        
        if !mode.isInfinity, runTimes >= mode.times {
            timer.cancel()
        }
        
        return self
    }
}

public extension YYTimer {
    enum Mode {
        case times(Int)
        
        var isInfinity: Bool {
            switch self {
            case .times(let times):
                return times.isInfinity
            }
        }
        
        var times: Int {
            switch self {
            case .times(let times):
                return times.isInfinity ? .infinity : times
            }
        }
    }
}






