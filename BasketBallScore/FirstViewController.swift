//
//  FirstViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/09.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit
import ChameleonFramework

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var TEAMNAME: UILabel!
    @IBOutlet weak var TODAY: UILabel!

    @IBOutlet weak var OFFICIAL_GAME: UIButton!
    @IBOutlet weak var PRACTICE_GAME: UIButton!
    @IBOutlet weak var PRACTICE: UIButton!
    
    
    @IBOutlet weak var makeScoreButton: UIButton!
    @IBOutlet weak var editTeamMateButton: UIButton!
    @IBOutlet weak var customizeButton: UIButton!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet var myTextFields: [UITextField]!
    
    
    
    var editingField:UITextField?
    var overlap:CGFloat = 0.0
    var lastOffsetY:CGFloat = 0.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        //改行コードは入力しない
        return false
    }
    
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (userDefaults.bool(forKey: Constants.ISSCORING) == true){
            showAlertIsScoring()
        }
        if (userDefaults.string(forKey: Constants.TEAMNAME) == nil){
            print("not defined")
            showAlertTeamName()
        }else{
            TEAMNAME.text = userDefaults.string(forKey: Constants.TEAMNAME)
        }
    }
    
    func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let now = Date()
        return formatter.string(from: now)
    }
    
    
    @IBAction func gotoStartMemberPage(_ sender: Any) {
        if myTextFields[0].text == ""{
            showAlertInputError(tag:0)
        }else if myTextFields[1].text == ""{
            showAlertInputError(tag:1)
        }else{
            userDefaults.set(myTextFields[0].text, forKey: Constants.TITLE)
            userDefaults.synchronize()
            userDefaults.set(myTextFields[1].text, forKey: Constants.OPPONENT)
            userDefaults.synchronize()
            if PRACTICE.backgroundColor == UIColor.flatSkyBlue(){
                //go to PracticeStartMenberPage
                userDefaults.set(true, forKey: Constants.ISSCORING)
                userDefaults.synchronize()
                print("スタメンページ始まり")
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PracticeStartMemberPage")
                nextVC?.modalTransitionStyle = .crossDissolve
                present(nextVC!, animated: true, completion: nil)
            }else{
                //go to GameStartMemberPage
                userDefaults.set(true, forKey: Constants.ISSCORING)
                userDefaults.synchronize()
                if OFFICIAL_GAME.backgroundColor == UIColor.flatSkyBlue(){
                    userDefaults.set(1, forKey: Constants.GAMETYPE)
                    userDefaults.synchronize()
                }
                if PRACTICE_GAME.backgroundColor == UIColor.flatSkyBlue(){
                    userDefaults.set(2, forKey: Constants.GAMETYPE)
                    userDefaults.synchronize()
                }
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GameStartMemberPage")
                nextVC?.modalTransitionStyle = .crossDissolve
                present(nextVC!, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TODAY.text = getTodayString()
        
        myScrollView.keyboardDismissMode = .onDrag
        for fld in myTextFields {
            fld.delegate = self
        }
        
        let notification = NotificationCenter.default
        
        //キーボードのframeが変化した
        notification.addObserver(self, selector: #selector(FirstViewController.keyboardChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        //キーボードが登場した
        notification.addObserver(self, selector: #selector(FirstViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //キーボードが退場した
        notification.addObserver(self, selector: #selector(FirstViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        //ゲームの種類ラベルをタップで色を変化させる
        OFFICIAL_GAME.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        PRACTICE_GAME.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        PRACTICE.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    func keyboardChangeFrame(_ notification: Notification){
        //編集中のテキストフィールドがない場合は中断する
        guard let fld = editingField else{
            return
        }
        //キーボードのframeを調べる
        let userInfo = (notification as NSNotification).userInfo!
        let keybordFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //テキストフィールドのframeをキーボードと同じ座標系にする
        let fldFrame = view.convert(fld.frame, from: contentView)
        //編集中のテキストフィールドがキーボードと重なっていないか調べる
        overlap = fldFrame.maxX - keybordFrame.minY
        if overlap>0{
            //キーボードで隠れているぶんだけスクロールする
            //overlap += myScrollView.contentOffset.y
            //myScrollView.setContentOffset(CGPoint(x: 0, y: overlap), animated: true)
        }
    }
    
    func keyboardWillShow(_ notification: Notification){
        //現在のスクロール量を保存しておく
        lastOffsetY = myScrollView.contentOffset.y
    }
    
    func keyboardDidHide(_ notification: Notification){
        //スクロールを元に戻す
        let baseline = (contentView.bounds.height - myScrollView.bounds.height)
        lastOffsetY = min(baseline, lastOffsetY)
        myScrollView.setContentOffset(CGPoint(x:0, y: lastOffsetY), animated: true)
    }

    
    func changeKindButtonColor(_ sender:UIButton){
        switch sender {
        case OFFICIAL_GAME:
            print("official game")
            OFFICIAL_GAME.backgroundColor = UIColor.flatSkyBlue()
            OFFICIAL_GAME.tintColor = UIColor.flatWhite()
            PRACTICE_GAME.backgroundColor = UIColor.flatWhite()
            PRACTICE_GAME.tintColor = UIColor.flatBlack()
            PRACTICE.backgroundColor = UIColor.flatWhite()
            PRACTICE.tintColor = UIColor.flatBlack()
        case PRACTICE_GAME:
            print("practice game")
            OFFICIAL_GAME.backgroundColor = UIColor.flatWhite()
            OFFICIAL_GAME.tintColor = UIColor.flatBlack()
            PRACTICE_GAME.backgroundColor = UIColor.flatSkyBlue()
            PRACTICE_GAME.tintColor = UIColor.flatWhite()
            PRACTICE.backgroundColor = UIColor.flatWhite()
            PRACTICE.tintColor = UIColor.flatBlack()
        case PRACTICE:
            print("practice")
            OFFICIAL_GAME.backgroundColor = UIColor.flatWhite()
            OFFICIAL_GAME.tintColor = UIColor.flatBlack()
            PRACTICE_GAME.backgroundColor = UIColor.flatWhite()
            PRACTICE_GAME.tintColor = UIColor.flatBlack()
            PRACTICE.backgroundColor = UIColor.flatSkyBlue()
            PRACTICE.tintColor = UIColor.flatWhite()
        default:
            print("error")
        }
    }
    
    func showAlertTeamName() {
        
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "ようこそBascoへ！", message: "まずはチーム名を設定をしよう", preferredStyle: .alert)
        // OKボタンの設定
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "チーム名"
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let textfields = alert.textFields{
                for textfield in textfields{
                    self.userDefaults.set(textfield.text, forKey: Constants.TEAMNAME)
                    self.userDefaults.synchronize()
                    self.TEAMNAME.text = textfield.text
                }
            }
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EditTeamPage")
            //nextVC?.modalTransitionStyle = .flipHorizontal
            self.present(nextVC!, animated: true, completion: nil)
            
        })
        alert.addAction(okAction)
        
       
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertInputError(tag:Int){
        var msg = ""
        switch tag{
        case 0:
            //苗字
            msg = "タイトルを入力してください"
        case 1:
            msg = "対戦相手を入力してください"
        default:
            break
        }
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "入力ミス", message: msg, preferredStyle: .alert)
        // OKボタンの設定
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
        })
        alert.addAction(okAction)
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertIsScoring(){
        let alert = UIAlertController(title: "スコアを作成途中です", message: "作成を続けますか？", preferredStyle: .alert)
        // OKボタンの設定
        
        // テキストフィールドを追加
        //alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
        //    textField.placeholder = "チーム名"
        //})
        
        let okAction = UIAlertAction(title: "続ける", style: .default, handler: {
            (action:UIAlertAction!) -> Void in

            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Score1Page")
            //nextVC?.modalTransitionStyle = .flipHorizontal
            self.present(nextVC!, animated: true, completion: nil)
            
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "続けない", style: .destructive, handler: {
            (action:UIAlertAction!) -> Void in
            self.showAlertDelete()

            //self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertDelete(){
        let alert = UIAlertController(title: "本当に続けないですか？", message: "作成中のデータは全て消去されます", preferredStyle: .alert)
        // OKボタンの設定
        
        // テキストフィールドを追加
        //alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
        //    textField.placeholder = "チーム名"
        //})
        
        let okAction = UIAlertAction(title: "続けない", style: .destructive, handler: {
            (action:UIAlertAction!) -> Void in
            self.userDefaults.set(false,forKey: Constants.ISSCORING)
            self.userDefaults.synchronize()
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "続ける", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Score1Page")
            //nextVC?.modalTransitionStyle = .flipHorizontal
            self.present(nextVC!, animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
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
