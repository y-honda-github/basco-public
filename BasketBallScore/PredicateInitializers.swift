//
//  PredicateInitializers.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/04/12.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import Foundation

public extension NSPredicate {
    
    private convenience init(expression property: String, _ operation: String, _ value: AnyObject) {
        self.init(format: "\(property) \(operation) %@", argumentArray: [value])
    }
    public convenience init(_ property: String, equal value: AnyObject) {
        self.init(expression: property, "=", value)
    }
    
    public convenience init(_ property: String, notEqual value: AnyObject) {
        self.init(expression: property, "!=", value)
    }
    
    public convenience init(_ property: String, equalOrGreaterThan value: AnyObject) {
        self.init(expression: property, ">=", value)
    }
    
    public convenience init(_ property: String, equalOrLessThan value: AnyObject) {
        self.init(expression: property, "<=", value)
    }
    
    public convenience init(_ property: String, greaterThan value: AnyObject) {
        self.init(expression: property, ">", value)
    }
    
    public convenience init(_ property: String, lessThan value: AnyObject) {
        self.init(expression: property, "<", value)
    }

    // 前後方一致検索(いわゆる、あいまい検索)
    public convenience init(_ property: String, contains q: String) {
        self.init(format: "\(property) CONTAINS '\(q)'")
    }
    
    // 前方一致検索
    public convenience init(_ property: String, beginsWith q: String) {
        self.init(format: "\(property) BEGINSWITH '\(q)'")
    }
    
    // 後方一致検索
    public convenience init(_ property: String, endsWith q: String) {
        self.init(format: "\(property) ENDSWITH '\(q)'")
    }
    
    //IN句
    public convenience init(_ property: String, valuesIn values: [AnyObject]) {
        self.init(format: "\(property) IN %@", argumentArray: [values])
    }
    
    //BETWEEN句
    public convenience init(_ property: String, between min: AnyObject, to max: AnyObject) {
        self.init(format: "\(property) BETWEEN {%@, %@}", argumentArray: [min, max])
    }
    
    
    //日付のFromTo
    public convenience init(_ property: String, fromDate: NSDate?, toDate: NSDate?) {
        var format = "", args = [AnyObject]()
        if let from = fromDate {
            format += "\(property) >= %@"
            args.append(from)
        }
        if let to = toDate {
            if !format.isEmpty {
                format += " AND "
            }
            format += "\(property) <= %@"
            args.append(to)
        }
        if !args.isEmpty {
            self.init(format: format, argumentArray: args)
        } else {
            self.init(value: true)
        }
    }
   
    public convenience init(realmids: [Int]) {
        let arr = realmids.map { NSNumber(value: $0) }
        self.init(format: "id IN %@", argumentArray: [arr])
    }
    
    public convenience init(realmid: Int) {
        self.init(format: "id = %@", argumentArray: [NSNumber(value: realmid)])
    }
    
    public func compound(predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) -> NSPredicate {
        var p = predicates; p.insert(self, at: 0)
        switch type {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: p)
        case .or:  return NSCompoundPredicate(orPredicateWithSubpredicates:  p)
        case .not: return NSCompoundPredicate(notPredicateWithSubpredicate:  self.compound(predicates: p))
        }
    }
    
    public func and(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .and)
    }
    
    public func or(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .or)
    }
    
    public func not(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .not)
    }
    
    public static var empty: NSPredicate {
        return NSPredicate(value: true)
    }
}
