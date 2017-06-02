//
//  ScoreRealm.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/08.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit
import RealmSwift

class ScoreRealm: Object {
    static let realm = try! Realm(configuration: setDefaultRealmForUser(filename: "SCORE_REALM"))
    
    
    //管理用 id プライマリキー
    dynamic var id:Int = 0
    
    //プレイヤーid
    dynamic var player_id = 0
    
    //試合id
    dynamic var game_id:Int = 0
    
    //クウォーター
    dynamic var quarter = 0
    
    //シュート場所
    dynamic var shoot_place = 0
    
    //インかアウトか
    dynamic var isIn = true
    
    enum shootPlace:Int {
        //case free_throw = -1
        case paint_l_0 = 0
        case paint_l_45 = 1
        case paint_top = 2
        case paint_r_45 = 3
        case paint_r_0 = 4
        case middle_l_0 = 5
        case middle_l_45 = 6
        case middle_top = 7
        case middle_r_45 = 8
        case middle_r_0 = 9
        case three_l_0 = 10
        case three_l_45 = 11
        case three_top = 12
        case three_r_45 = 13
        case three_r_0 = 14
        case free_throw = 15
    }
    
    
    
    
    /**
     idをプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> ScoreRealm {
        let score = ScoreRealm()
        score.id = lastId()
        return score
    }
    
    
    static func loadAll() -> [ScoreRealm] {
        let users = realm.objects(ScoreRealm.self).sorted(byKeyPath: "id", ascending: true)
        var ret: [ScoreRealm] = []
        for user in users {
            ret.append(user)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let score = realm.objects(ScoreRealm.self).sorted(byKeyPath: "id", ascending: true).last {
            return score.id + 1
        } else {
            return 1
        }
    }
    
    static func allDelete(){
        try! ScoreRealm.realm.write {
            ScoreRealm.realm.deleteAll()
        }
    }
    
    static func deleteOf(_ ids: [Int]){
        //idの文字をid+1に変える
        //最後を消す
        let scores = realm.objects(ScoreRealm.self)
        var pos_id:Int
        // var current:String
        var end = scores.count
        var start_id = 0
        if(ids.count != 0){
            start_id = ids.first!
        }else{
            return
        }
        print("更新前")
        let users1 = ScoreRealm.loadAll()
        print(users1)
        for round in 1 ... ids.count{
            end = scores.count
            var id = start_id
            //for id in start ... end-1{
            while(id <= end-1){
                pos_id = id+1
                print("id=",id)
                try! realm.write {
                    //players.filter("id=%@",id).first?.body = (players.filter("id=%@",pos_id).first?.body)!
                }
                id = id + 1
            }
            print("更新後")
            let users2 = ScoreRealm.loadAll()
            print(users2)
            
            if let last = scores.last {
                // さようなら・・・
                try! realm.write() {
                    realm.delete(last)
                }
            }
            print("最後を消した後")
            let users3 = ScoreRealm.loadAll()
            print(users3)
            if(round<ids.count) {
                start_id = ids[round] - round
            }
            
        }
        
    }
    
    static func delete(player: Int){
        let predicate = NSPredicate(realmid: player)
        print("ok1")
        let results = ScoreRealm.realm.objects(ScoreRealm.self).filter(predicate)
        print("ok2")
        for result in results{
            try! realm.write {
                realm.delete(result)
                print("ok3")
            }
        }
        print("ok4")
    }
    
    // addのみ
    func save() {
        try! ScoreRealm.realm.write {
            ScoreRealm.realm.add(self)
        }
    }
    
    func update(method: (() -> Void)) {
        try! ScoreRealm.realm.write {
            method()
        }
    }
    
    static func setDefaultRealmForUser(filename: String) ->Realm.Configuration{
        var config = Realm.Configuration(schemaVersion: 1)
        
        // 保存先のディレクトリはデフォルトのままで、ファイル名をユーザー名を使うように変更します
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(filename).realm")
        
        // ConfigurationオブジェクトをデフォルトRealmで使用するように設定します
        //Realm.Configuration.defaultConfiguration = config
        return config
    }

}
