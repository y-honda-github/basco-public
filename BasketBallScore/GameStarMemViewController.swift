//
//  GameStarMemViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/04/04.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class GameStarMemViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    var playerList = Dictionary<Int,(UILabel,UIStackView)>()
    
    var playerId:Int = 0
    
    @IBOutlet weak var playerListStack: UIStackView!
    @IBOutlet var starMemLabel: [UILabel]!
    @IBOutlet weak var makeScoreButton: UIButton!
    var starMemIsDecided: [Bool] = [false, false, false, false, false]
    
    
    @IBAction func goToScore1Page(_ sender: Any) {
        userDefaults.set(starMemLabel[0].tag, forKey: Constants.PLAYER1)
        userDefaults.synchronize()
        userDefaults.set(starMemLabel[1].tag, forKey: Constants.PLAYER2)
        userDefaults.synchronize()
        userDefaults.set(starMemLabel[2].tag, forKey: Constants.PLAYER3)
        userDefaults.synchronize()
        userDefaults.set(starMemLabel[3].tag, forKey: Constants.PLAYER4)
        userDefaults.synchronize()
        userDefaults.set(starMemLabel[4].tag, forKey: Constants.PLAYER5)
        userDefaults.synchronize()
        userDefaults.set("1", forKey: Constants.QUARTER)
        userDefaults.synchronize()
        userDefaults.set(true, forKey: Constants.ISSCORING)
        userDefaults.synchronize()
        let gamerealm = GameRealm.create()
        gamerealm.title = userDefaults.string(forKey: Constants.TITLE)!
        gamerealm.opponent = userDefaults.string(forKey: Constants.OPPONENT)!
        gamerealm.game_type = userDefaults.integer(forKey: Constants.GAMETYPE)
        gamerealm.save()
        print("スタメンページ終わり")
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Score1Page")
        nextVC?.modalTransitionStyle = .crossDissolve
        present(nextVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func backToPrePage(_ sender: Any) {
        userDefaults.set(false, forKey: Constants.ISSCORING)
        userDefaults.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlayerList()
        //self.dismiss(animated: true, completion: nil)
        // Do any additional setup after loading the view.
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
        }
    }
    
    func highlightLabel(_ sender:UITapGestureRecognizer){
        playerId = (sender.view?.tag)!
        print("id=",playerId)
        let playerlist = playerList[playerId]
        
        if playerlist?.0.backgroundColor != UIColor.flatSkyBlue(){
            playerlist?.0.backgroundColor = UIColor.flatSkyBlue()
            addStarMem(id: playerId, name: (playerlist?.0.text)!)
            //starMemLabelをいじる
        }else{
            playerlist?.0.backgroundColor = UIColor.flatWhite()
            removeStarMem(id: playerId)
            //starMemLabelをいじる
        }
        checkButtonEnable()
    }
    
    func checkButtonEnable(){
        for isDecided in starMemIsDecided{
            if !isDecided{
                makeScoreButton.isEnabled = false
                return
            }
        }
        makeScoreButton.isEnabled = true
    }
    
    func isAddbleStarMem() -> Bool{
        for label in starMemLabel{
            if label.text == ""{
                return true
            }
        }
        return false
    }
    
    func addStarMem(id: Int, name: String){
        for i in 0...4{
            if !starMemIsDecided[i]{
                starMemLabel[i].text = name
                starMemLabel[i].tag = id
                starMemIsDecided[i] = true
                return
            }
        }
        playerList[(starMemLabel.last?.tag)!]?.0.backgroundColor = UIColor.flatWhite()
        starMemLabel.last?.text = name
        starMemLabel.last?.tag = playerId
    }
    
    func removeStarMem(id: Int){
        for i in 0...4{
            if starMemLabel[i].tag == id{
                starMemLabel[i].text = "player" + String(i + 1)
                starMemLabel[i].tag = 0
                starMemIsDecided[i] = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: Constants.ISSCORING) == false{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //終了したなら戻る
//        if
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
