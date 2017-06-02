//
//  StringRealm.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/04/12.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import Foundation

public extension String {
    
    /// Realm用にエスケープした文字列
    public var realmEscaped: String {
        let reps = [
            "\\" : "\\\\",
            "'"  : "\\'",
            ]
        var ret = self
        for rep in reps {
            //ret = self.stringByReplacingOccurrencesOfString(rep.0, withString: rep.1)
            ret = self.replacingOccurrences(of: rep.0, with: rep.1)
        }
        return ret
    }
}
