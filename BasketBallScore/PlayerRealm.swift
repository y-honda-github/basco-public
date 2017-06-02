//
//  PlayerRealm.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/08.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerRealm: Object {

    static let realm = try! Realm(configuration: setDefaultRealmForUser(filename: "PLAYER_REALM"))
    
    
    
    //管理用 id プライマリキー
    dynamic var id:Int = 0
    
    //名前
    dynamic var first_name = ""
    
    //苗字
    dynamic var last_name = ""
    
    //名前(english)
    dynamic var first_name_eng = ""
    
    //苗字(english)
    dynamic var last_name_eng = ""
    
    //ゼッケン番号
    dynamic var number = ""
    
    //入学年
    dynamic var admission_year = 0
    
    //引退しているかどうか
    dynamic var isRetired = false
    
    
    /**
     idをプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> PlayerRealm {
        let player = PlayerRealm()
        player.id = lastId()
        return player
    }
    
    //入団年順(降順)，アルファベット順
    static func loadAll() -> [PlayerRealm] {
        let sortProperties =
            [SortDescriptor(keyPath: "admission_year", ascending: false),
             SortDescriptor(keyPath: "last_name_eng", ascending: true),
             SortDescriptor(keyPath: "first_name_eng", ascending: true)]
        let users = realm.objects(PlayerRealm.self).sorted(by: sortProperties)
        var ret: [PlayerRealm] = []
        for user in users {
            ret.append(user)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let player = realm.objects(PlayerRealm.self).sorted(byKeyPath: "id",ascending: true).last {
            return player.id + 1
        } else {
            return 1
        }
    }
    
    static func allDelete(){
        try! PlayerRealm.realm.write {
            PlayerRealm.realm.deleteAll()
        }
    }
    
    static func deleteOf(_ ids: [Int]){
        //idの文字をid+1に変える
        //最後を消す
        let players = realm.objects(PlayerRealm.self)
        var pos_id:Int
        // var current:String
        var end = players.count
        var start_id = 0
        if(ids.count != 0){
            start_id = ids.first!
        }else{
            return
        }
        print("更新前")
        let users1 = PlayerRealm.loadAll()
        print(users1)
        for round in 1 ... ids.count{
            end = players.count
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
            let users2 = PlayerRealm.loadAll()
            print(users2)
            
            if let last = players.last {
                // さようなら・・・
                try! realm.write() {
                    realm.delete(last)
                }
            }
            print("最後を消した後")
            let users3 = PlayerRealm.loadAll()
            print(users3)
            if(round<ids.count) {
                start_id = ids[round] - round
            }
            
        }
        
    }
    
    static func delete(player: Int){
        if let result = realm.object(ofType: PlayerRealm.self, forPrimaryKey: player){
            try! realm.write {
                realm.delete(result)
            }
        }
    }
    // addのみ
    func save() {
        try! PlayerRealm.realm.write {
            PlayerRealm.realm.add(self)
        }
    }
    
    func update(method: (() -> Void)) {
        try! PlayerRealm.realm.write {
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
