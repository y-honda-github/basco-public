//
//  GameExchangeMemberViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/04/29.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class GameExchangeMemberViewController: UIViewController {

    
    let userDefaults = UserDefaults.standard
    
    var playerList = Dictionary<Int,(UILabel,UIStackView)>()
    
    var playerId:Int = 0
    
    @IBOutlet weak var playerListStack: UIStackView!
    @IBOutlet var memLabel: [UILabel]!
    @IBOutlet weak var makeScoreButton: UIButton!
    var memIsDecided: [Bool] = [true, true, true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlayerList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func goToScore1Page(_ sender: Any) {
        userDefaults.set(memLabel[0].tag, forKey: Constants.PLAYER1)
        userDefaults.synchronize()
        userDefaults.set(memLabel[1].tag, forKey: Constants.PLAYER2)
        userDefaults.synchronize()
        userDefaults.set(memLabel[2].tag, forKey: Constants.PLAYER3)
        userDefaults.synchronize()
        userDefaults.set(memLabel[3].tag, forKey: Constants.PLAYER4)
        userDefaults.synchronize()
        userDefaults.set(memLabel[4].tag, forKey: Constants.PLAYER5)
        userDefaults.synchronize()
        userDefaults.set("1", forKey: Constants.QUARTER)
        userDefaults.synchronize()
        userDefaults.set(true, forKey: Constants.ISSCORING)
        userDefaults.synchronize()
        
        print("スタメンページ終わり")
        self.dismiss(animated: true, completion: nil)
    }
    
    func showPlayerList(){
        if !playerList.isEmpty{
            //一旦空にする
            //全部消す
            for substack in playerList{
                playerListStack.removeArrangedSubview(substack.value.1)
            }
            playerList.removeAll()
        }
        
        //現役選手のみ表示
        let predicate = NSPredicate(format:"isRetired == FALSE")
        let results = PlayerRealm.realm.objects(PlayerRealm.self).filter(predicate)
        for player in results{
            //リスト一つにつき，tapGestureのインスタンスを生成する必要あり
            let tapGesture = UITapGestureRecognizer(target: self,action: #selector(self.highlightLabel(_:)))
            let substack = UIStackView()
            substack.addGestureRecognizer(tapGesture)
            substack.tag = player.id
            
            let body = UILabel()
            //body.font = UIFont.systemFont(ofSize: CGFloat(20))
            body.text = "\(player.last_name) \(player.first_name)"
            body.numberOfLines = 0
            body.backgroundColor = UIColor.flatWhite()
            body.textAlignment = .center
            playerList[player.id] = (body,substack)
            substack.addArrangedSubview(body)
            playerListStack.addArrangedSubview(substack)
            switch player.id {
            case userDefaults.integer(forKey: Constants.PLAYER1):
                body.backgroundColor = UIColor.flatSkyBlue()
                memLabel[0].text = player.last_name + " " + player.first_name
                memLabel[0].tag = player.id
            case userDefaults.integer(forKey: Constants.PLAYER2):
                body.backgroundColor = UIColor.flatSkyBlue()
                memLabel[1].text = player.last_name + " " + player.first_name
                memLabel[1].tag = player.id
            case userDefaults.integer(forKey: Constants.PLAYER3):
                body.backgroundColor = UIColor.flatSkyBlue()
                memLabel[2].text = player.last_name + " " + player.first_name
                memLabel[2].tag = player.id
            case userDefaults.integer(forKey: Constants.PLAYER4):
                body.backgroundColor = UIColor.flatSkyBlue()
                memLabel[3].text = player.last_name + " " + player.first_name
                memLabel[3].tag = player.id
            case userDefaults.integer(forKey: Constants.PLAYER5):
                body.backgroundColor = UIColor.flatSkyBlue()
                memLabel[4].text = player.last_name + " " + player.first_name
                memLabel[4].tag = player.id
            default:
                break
            }

        }
    }
    
    
    func highlightLabel(_ sender:UITapGestureRecognizer){
        playerId = (sender.view?.tag)!
        print("id=",playerId)
        let playerlist = playerList[playerId]
        
        if playerlist?.0.backgroundColor != UIColor.flatSkyBlue(){
            playerlist?.0.backgroundColor = UIColor.flatSkyBlue()
            addMem(id: playerId, name: (playerlist?.0.text)!)
            //memLabelをいじる
        }else{
            playerlist?.0.backgroundColor = UIColor.flatWhite()
            removemem(id: playerId)
            //memLabelをいじる
        }
        checkButtonEnable()
    }
    
    func checkButtonEnable(){
        for isDecided in memIsDecided{
            if !isDecided{
                makeScoreButton.isEnabled = false
                return
            }
        }
        makeScoreButton.isEnabled = true
    }
    func isAddblemem() -> Bool{
        for label in memLabel{
            if label.text == ""{
                return true
            }
        }
        return false
    }
    
    func addMem(id: Int, name: String){
        for i in 0...4{
            if !memIsDecided[i]{
                memLabel[i].text = name
                memLabel[i].tag = id
                memIsDecided[i] = true
                return
            }
        }
        playerList[(memLabel.last?.tag)!]?.0.backgroundColor = UIColor.flatWhite()
        memLabel.last?.text = name
        memLabel.last?.tag = playerId
    }
    
    func removemem(id: Int){
        for i in 0...4{
            if memLabel[i].tag == id{
                memLabel[i].text = "player" + String(i + 1)
                memLabel[i].tag = 0
                memIsDecided[i] = false
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
