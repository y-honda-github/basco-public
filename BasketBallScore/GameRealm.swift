//
//  GameRealm.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/08.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit
import RealmSwift

class GameRealm: Object {
    static let realm = try! Realm(configuration: setDefaultRealmForUser(filename: "GAME_REALM"))
    
    
    //管理用 id プライマリキー
    dynamic var id:Int = 0
    
    //タイトル
    dynamic var title = ""
    
    //相手チーム
    dynamic var opponent = ""
    
    //日にち
    dynamic var day = Date()
    
    //ゲームの種類(公式戦，練習試合，練習)
    dynamic var game_type = 0
    
    enum gameType:Int {
        case official_game = 1
        case practice_game = 2
        case practice = 3
    }
    
    
    
    /**
     idをプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> GameRealm {
        let game = GameRealm()
        game.id = lastId()
        return game
    }
    
    
    static func loadAll() -> [GameRealm] {
        let users = realm.objects(GameRealm.self).sorted(byKeyPath: "id", ascending: true)
        var ret: [GameRealm] = []
        for user in users {
            ret.append(user)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let game = realm.objects(GameRealm.self).sorted(byKeyPath: "id", ascending: true).last {
            return game.id + 1
        } else {
            return 1
        }
    }
    
    static func allDelete(){
        try! GameRealm.realm.write {
            GameRealm.realm.deleteAll()
        }
    }
    
    static func deleteOf(_ ids: [Int]){
        //idの文字をid+1に変える
        //最後を消す
        let games = realm.objects(GameRealm.self)
        var pos_id:Int
        // var current:String
        var end = games.count
        var start_id = 0
        if(ids.count != 0){
            start_id = ids.first!
        }else{
            return
        }
        print("更新前")
        let users1 = GameRealm.loadAll()
        print(users1)
        for round in 1 ... ids.count{
            end = games.count
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
            let users2 = GameRealm.loadAll()
            print(users2)
            
            if let last = games.last {
                // さようなら・・・
                try! realm.write() {
                    realm.delete(last)
                }
            }
            print("最後を消した後")
            let users3 = GameRealm.loadAll()
            print(users3)
            if(round<ids.count) {
                start_id = ids[round] - round
            }
            
        }
        
    }
    
    // addのみ
    func save() {
        try! GameRealm.realm.write {
            GameRealm.realm.add(self)
        }
    }
    
    func update(method: (() -> Void)) {
        try! GameRealm.realm.write {
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
