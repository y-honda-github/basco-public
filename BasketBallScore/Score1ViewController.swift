//
//  Score1ViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/04.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit
import SnapKit

class Score1ViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var TITLE: UILabel!
    @IBOutlet weak var OPPONENT: UILabel!
    @IBOutlet weak var QUARTER: UILabel!
    @IBOutlet weak var PLAYER1: UILabel!
    @IBOutlet weak var PLAYER2: UILabel!
    @IBOutlet weak var PLAYER3: UILabel!
    @IBOutlet weak var PLAYER4: UILabel!
    @IBOutlet weak var PLAYER5: UILabel!
    @IBOutlet weak var FIELD: UIImageView!
    
   
    
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player3Button: UIButton!
    @IBOutlet weak var player4Button: UIButton!
    @IBOutlet weak var player5Button: UIButton!
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var currentPlayerButton = UIButton()
    var prePlayerButton = UIButton()
    
    var currentPlace = -1
    var currentIsIn = false
   
    
    let shootPlace = [-1:"フリースロー",0:"左0度 ゴール下",1:"左45度 ゴール下",2:"90度 ゴール下",3:"右45度 ゴール下",4:"右0度 ゴール下",5:"左0度 ミドル",6:"左45度 ミドル",7:"90度 ミドル",8:"右45度 ミドル",9:"右0度 ミドル",10:"左0度 スリー",11:"左45度 スリー",12:"90度 スリー",13:"右45度 スリー",14:"右0度 スリー"]
    
    
    @IBOutlet weak var player2Button: UIButton!
    
    var FIELD_WIDTH:CGFloat {
        get{
            return(FIELD.frame.size.width)
        }
    }
    var FIELD_HEIGHT:CGFloat {
        get{
            return(FIELD.frame.size.height)
        }
    }
    
    var RING_COORD:(x:CGFloat,y:CGFloat) {
        get{
            return((FIELD_WIDTH / 2.0 ,FIELD_HEIGHT * 0.9))
        }
    }
    
    var ORIGIN_COORD:(x:CGFloat,y:CGFloat){
        get{
            return((FIELD_WIDTH / 2.0 ,FIELD_HEIGHT))
        }
    }
    
    var RADIUS:(x:CGFloat,y:CGFloat){
        get{
            return((FIELD_WIDTH * 0.4,FIELD_HEIGHT * 3.0 / 4.0))
        }
    }
    
    var PAINT_SIZE:(x:CGFloat,y:CGFloat){
        get{
            return((FIELD_WIDTH * 3.0 / 20.0 ,FIELD_HEIGHT / 2.0))
        }
    }
    
    var count = 1
    var tapLocation:CGPoint = CGPoint()
    
    func isTrheePointArea(_ location:CGPoint) -> Bool{
        if(((location.x - ORIGIN_COORD.x) * (location.x - ORIGIN_COORD.x)) / (RADIUS.x * RADIUS.x) + ((location.y - ORIGIN_COORD.y) * (location.y - ORIGIN_COORD.y)) / (RADIUS.y * RADIUS.y) > 1.0){
            return(true)
        }else{
            return(false)
        }
    }
    
    func isMiddleArea(_ location:CGPoint) -> Bool{
        if(((location.x - ORIGIN_COORD.x) * (location.x - ORIGIN_COORD.x)) / (RADIUS.x * RADIUS.x) + ((location.y - ORIGIN_COORD.y) * (location.y - ORIGIN_COORD.y)) / (RADIUS.y * RADIUS.y) <= 1.0 && (fabs(location.x - ORIGIN_COORD.x) > PAINT_SIZE.x || fabs(location.y - ORIGIN_COORD.y) > PAINT_SIZE.y)){
            return(true)
        }else{
            return(false)
        }
    }
    
    func isPaintArea(_ location:CGPoint) -> Bool{
        if((fabs(location.x - ORIGIN_COORD.x) <= PAINT_SIZE.x && fabs(location.y - ORIGIN_COORD.y) <= PAINT_SIZE.y)){
            return(true)
        }else{
            return(false)
        }
    }
    
    func getAreaOf(location:CGPoint) -> Int{
        if(isTrheePointArea(location)){
            return(2)
        }else if(isMiddleArea(location)){
            return(1)
        }else if(isPaintArea(location)){
            return(0)
        }else{
            return(-1)
        }
    }
    
    func getAngleOf(location:CGPoint) -> Int{
        if(location.x == RING_COORD.x){
            return(2)
        }
        let angle:CGFloat = -(location.y - RING_COORD.y) / (location.x - RING_COORD.x)
        if(location.x - RING_COORD.x >= 0.0 ){
            if(Double(angle) < tan(.pi * 3.0 / 32.0)){
                return(0)
            }else if(Double(angle) < tan(.pi * 13.0 / 32.0)){
                return(1)
            }else{
                return(2)
            }
        }else{
            if(Double(-angle) < tan(.pi * 3.0 / 32.0)){
                return(4)
            }else if(Double(-angle) < tan(.pi * 13.0 / 32.0)){
                return(3)
            }else{
                return(2)
            }
        }
    }
    
    @IBAction func tapField(_ sender: UITapGestureRecognizer) {
        print("tapped")
        
        print(count)
        count = count + 1
        
        //画像の左上を(0.0)とした座標系
        tapLocation = sender.location(in: FIELD)
        print(getAreaOf(location:tapLocation))
        //OPPONENT.text = getAreaOf(location:tapLocation)
        print(getAngleOf(location:tapLocation))
        //TITLE.text = getAngleOf(location:tapLocation)
        prePlayerButton = UIButton()
        player1Button.backgroundColor = UIColor.flatWhite()
        player2Button.backgroundColor = UIColor.flatWhite()
        player3Button.backgroundColor = UIColor.flatWhite()
        player4Button.backgroundColor = UIColor.flatWhite()
        player5Button.backgroundColor = UIColor.flatWhite()
        inButton.backgroundColor = UIColor.flatWhite()
        outButton.backgroundColor = UIColor.flatWhite()
        okButton.isEnabled = checkOkButton()
        showInputView(location: tapLocation)
        
    }
   
    @IBAction func tapFreeThrowButton(_ sender: Any) {
        prePlayerButton = UIButton()
        player1Button.backgroundColor = UIColor.flatWhite()
        player2Button.backgroundColor = UIColor.flatWhite()
        player3Button.backgroundColor = UIColor.flatWhite()
        player4Button.backgroundColor = UIColor.flatWhite()
        player5Button.backgroundColor = UIColor.flatWhite()
        inButton.backgroundColor = UIColor.flatWhite()
        outButton.backgroundColor = UIColor.flatWhite()
        okButton.isEnabled = checkOkButton()
        showInputView(location: nil)
    }
    
    @IBAction func tapTimeUpButton(_ sender: Any) {
        showAlertTimeUp()
    }
    
    func showAlertTimeUp(){
        let alert = UIAlertController(title: "\(String(describing: QUARTER.text!))を終了します", message: "", preferredStyle: .alert)
        // 次のクォーターの設定
        if userDefaults.string(forKey: Constants.QUARTER) != "4"{
            let nextAction = UIAlertAction(title: "次のクォーターへ", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                let next = Int(self.userDefaults.string(forKey: Constants.QUARTER)!)! + 1
                self.userDefaults.set(String(next),forKey: Constants.QUARTER)
                self.userDefaults.synchronize()
                self.QUARTER.text = "第" + self.userDefaults.string(forKey: Constants.QUARTER)! + "Q"
            })
            alert.addAction(nextAction)
        }
        // 終了ボタンの設
        let finishAction = UIAlertAction(title: "スコア作成を終了する", style: .destructive, handler: {
            (action:UIAlertAction!) -> Void in
            self.showAlertFinish()
            
            
        })
        alert.addAction(finishAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action:UIAlertAction!) -> Void in
            //self.showAlertDelete()
            
            //self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertFinish(){
        let alert = UIAlertController(title: "本当にスコア作成を終了しますか？", message: "", preferredStyle: .alert)
        // 次のクォーターの設定
    
        let finishAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            self.userDefaults.set(false, forKey: Constants.ISSCORING)
            self.userDefaults.synchronize()
            self.dismiss(animated: true, completion: nil)
            
        })
        alert.addAction(finishAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action:UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInputView(location: CGPoint?){
        InputView.isHidden = false
        if location != nil{
            if (location?.x)! - RING_COORD.x >= 0{
                InputView.center.x = FIELD_WIDTH / 4
            }else{
                InputView.center.x = FIELD_WIDTH * 3 / 4
            }
            InputView.center.y = self.view.frame.height / 2
            currentPlace = 5 * getAreaOf(location: location!) + getAngleOf(location: location!)
            locationLabel.text = shootPlace[currentPlace]
        }else{
            InputView.center.x = FIELD_WIDTH / 2
            InputView.center.y = self.view.frame.height / 2
            currentPlace = 15
            locationLabel.text = "フリースロー"
        }
    }
    
    func selectPlayerButton(_ sender:UIButton){
        prePlayerButton = currentPlayerButton
        currentPlayerButton = sender
        if sender.backgroundColor != UIColor.flatSkyBlue(){
            sender.backgroundColor = UIColor.flatSkyBlue()
            if prePlayerButton != currentPlayerButton{
                prePlayerButton.backgroundColor = UIColor.flatWhite()
            }
        }else{
            sender.backgroundColor = UIColor.flatWhite()
            prePlayerButton = UIButton()
        }
        okButton.isEnabled = checkOkButton()
    }
    
    func selectInButton(_ sender:UIButton){
        if sender.backgroundColor != UIColor.flatSkyBlue(){
            sender.backgroundColor = UIColor.flatSkyBlue()
            outButton.backgroundColor = UIColor.flatWhite()
            currentIsIn = true
        }else{
            sender.backgroundColor = UIColor.flatWhite()
        }
        okButton.isEnabled = checkOkButton()
    }
    
    func selectOutButton(_ sender:UIButton){
        if sender.backgroundColor != UIColor.flatSkyBlue(){
            sender.backgroundColor = UIColor.flatSkyBlue()
            inButton.backgroundColor = UIColor.flatWhite()
            currentIsIn = false
        }else{
            sender.backgroundColor = UIColor.flatWhite()
        }
        okButton.isEnabled = checkOkButton()
    }
    
    func checkOkButton() -> Bool{
        if ((player1Button.backgroundColor == UIColor.flatSkyBlue() ||
            player2Button.backgroundColor == UIColor.flatSkyBlue() ||
            player3Button.backgroundColor == UIColor.flatSkyBlue() ||
            player4Button.backgroundColor == UIColor.flatSkyBlue() ||
            player5Button.backgroundColor == UIColor.flatSkyBlue()) &&
            (inButton.backgroundColor == UIColor.flatSkyBlue() ||
            outButton.backgroundColor == UIColor.flatSkyBlue())){
            return true
        }else{
            return false
        }

    }
    
    func pushOkButton(_ sender:UIButton){
        //realmに追加
        let scorerealm = ScoreRealm.create()
        scorerealm.game_id = (GameRealm.realm.objects(GameRealm.self).last?.id)!
        scorerealm.quarter = Int(userDefaults.string(forKey: Constants.QUARTER)!)!
        scorerealm.player_id = currentPlayerButton.tag
        scorerealm.shoot_place = currentPlace
        scorerealm.isIn = currentIsIn
        scorerealm.save()
        InputView.isHidden = true
        prePlayerButton.backgroundColor = UIColor.flatWhite()
        print(ScoreRealm.loadAll())
    }
    
    func pushCancelButton(_ sender:UIButton){
        InputView.isHidden = true
        prePlayerButton.backgroundColor = UIColor.flatWhite()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("戻った")
        let player1realm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: userDefaults.integer(forKey: Constants.PLAYER1))
        let player2realm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: userDefaults.integer(forKey: Constants.PLAYER2))
        let player3realm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: userDefaults.integer(forKey: Constants.PLAYER3))
        let player4realm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: userDefaults.integer(forKey: Constants.PLAYER4))
        let player5realm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: userDefaults.integer(forKey: Constants.PLAYER5))
        //プレイヤーラベルのテキストを反映
        InputView.isHidden = true
        
        
        TITLE.text = userDefaults.string(forKey: Constants.TITLE)
        OPPONENT.text = userDefaults.string(forKey: Constants.OPPONENT)
        QUARTER.text = "第" + userDefaults.string(forKey: Constants.QUARTER)! + "Q"
        PLAYER1.text = (player1realm?.last_name)! + " " + (player1realm?.first_name)!
        PLAYER2.text = (player2realm?.last_name)! + " " + (player2realm?.first_name)!
        PLAYER3.text = (player3realm?.last_name)! + " " + (player3realm?.first_name)!
        PLAYER4.text = (player4realm?.last_name)! + " " + (player4realm?.first_name)!
        PLAYER5.text = (player5realm?.last_name)! + " " + (player5realm?.first_name)!
        
        player1Button.setTitle(PLAYER1.text, for: .normal)
        player1Button.tag = (player1realm?.id)!
        player2Button.setTitle(PLAYER2.text, for: .normal)
        player2Button.tag = (player2realm?.id)!
        player3Button.setTitle(PLAYER3.text, for: .normal)
        player3Button.tag = (player3realm?.id)!
        player4Button.setTitle(PLAYER4.text, for: .normal)
        player4Button.tag = (player4realm?.id)!
        player5Button.setTitle(PLAYER5.text, for: .normal)
        player5Button.tag = (player5realm?.id)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player1Button.addTarget(self, action: #selector(self.selectPlayerButton(_:)), for: .touchUpInside)
        player1Button.titleLabel?.textAlignment = .center
        player2Button.addTarget(self, action: #selector(self.selectPlayerButton(_:)), for: .touchUpInside)
        player2Button.titleLabel?.textAlignment = .center
        player3Button.addTarget(self, action: #selector(self.selectPlayerButton(_:)), for: .touchUpInside)
        player3Button.titleLabel?.textAlignment = .center
        player4Button.addTarget(self, action: #selector(self.selectPlayerButton(_:)), for: .touchUpInside)
        player4Button.titleLabel?.textAlignment = .center
        player5Button.addTarget(self, action: #selector(self.selectPlayerButton(_:)), for: .touchUpInside)
        player5Button.titleLabel?.textAlignment = .center
        inButton.addTarget(self, action: #selector(self.selectInButton(_:)), for: .touchUpInside)
        outButton.addTarget(self, action: #selector(self.selectOutButton(_:)), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(self.pushOkButton(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.pushCancelButton(_:)), for: .touchUpInside)
        print("start")
        print("width:" , FIELD_WIDTH)
        print("height:" , FIELD_HEIGHT)
        print("ring_x:" , RING_COORD.x)
        print("ring_y:" , RING_COORD.y)
    }

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
