//
//  EditTeamViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/04/04.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class EditTeamViewController: UIViewController, UITextFieldDelegate {
    
    var playerList = Dictionary<Int,(UILabel,UIStackView)>()
    var yearSet = Set<UILabel>()
    var prePlayerLabel = UILabel()
    
    
    @IBOutlet weak var nameLabel_jpn: UILabel!
    @IBOutlet weak var nameLabel_eng: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var retireLabel: UILabel!
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var retireButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var playerListStack: UIStackView!
    @IBOutlet var myTextFields: [UITextField]!
    
    var playerId:Int = 0
    
    var editingField:UITextField?
    var overlap:CGFloat = 0.0
    var lastOffsetY:CGFloat = 0.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingField = nil
    }
    
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        //改行コードは入力しない
        return false
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PlayerRealm.allDelete()
        
        for fld in myTextFields {
            fld.delegate = self
        }
        addButton.addTarget(self, action: #selector(self.addPlayer(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(self.startEditPlayer(_:)), for: .touchUpInside)
        retireButton.addTarget(self, action: #selector(self.retirePlayer(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deletePlayer(_:)), for: .touchUpInside)
        showPlayerList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkNoPlayer()
    }
    
    func addPlayer(_ sender:UIButton){
        //入力が正しいかを判定
        //日本語の名前オッケ？
        if myTextFields[0].text == ""{
            //showAlert()
            print("out0")
            showAlertInputError(tag: 0)
            return
        }
        if myTextFields[1].text == ""{
            //showAlert()
            print("out1")
            showAlertInputError(tag: 1)
            return
        }
        //英語(ローマ字)オッケ？
        if myTextFields[2].text?.isOnlyAlphabet == false || myTextFields[2].text == ""{
            //showAlert()
            print("out2")
            showAlertInputError(tag: 2)
            return
        }
        if myTextFields[3].text?.isOnlyAlphabet == false || myTextFields[3].text == ""{
            print("out3")
            showAlertInputError(tag: 3)
            return
        }
        //ナンバーおけ？
        if myTextFields[4].text?.isOnlyNumber == false || myTextFields[4].text == ""{
            //showAlert
            print("out4")
            showAlertInputError(tag: 4)
            return
        }
        //入団年おけ？
        if myTextFields[5].text?.isOnlyNumber == false || myTextFields[5].text == ""{
            //showAlert
            print("out5")
            showAlertInputError(tag: 5)
            return
        }
        //アウトならalert発生
        //追加
        let playerrealm = PlayerRealm.create()
        playerrealm.last_name = myTextFields[0].text!
        playerrealm.first_name = myTextFields[1].text!
        playerrealm.last_name_eng = myTextFields[2].text!
        playerrealm.first_name_eng = myTextFields[3].text!
        playerrealm.number = myTextFields[4].text!
        playerrealm.admission_year = Int(myTextFields[5].text!)!
        playerrealm.save()
        for textfield in myTextFields{
            textfield.text = ""
        }
        showPlayerList()
    }

    func startEditPlayer(_ sender:UIButton){
        //textfieldに反映させる
        let name_jpn = nameLabel_jpn.text?.components(separatedBy: " ")
        let name_eng = nameLabel_eng.text?.components(separatedBy: " ")
        let number = numberLabel.text
        let year = yearLabel.text
        myTextFields[0].text = name_jpn?[0]
        myTextFields[1].text = name_jpn?[1]
        myTextFields[2].text = name_eng?[0]
        myTextFields[3].text = name_eng?[1]
        let index = number?.index((number?.startIndex)!, offsetBy: 1)
        myTextFields[4].text = number?.substring(from: index!)
        myTextFields[5].text = year
        
        addButton.titleLabel?.text = "完了"
        addButton.removeTarget(self, action: #selector(self.addPlayer(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.endEditPlayer(_:)), for: .touchUpInside)
    }
    
    func endEditPlayer(_ sender:UIButton){
        //入力が正しいかを判定
        //日本語の名前オッケ？
        if myTextFields[0].text == ""{
            //showAlert()
            print("out0")
            showAlertInputError(tag: 0)
            return
        }
        if myTextFields[1].text == ""{
            //showAlert()
            print("out1")
            showAlertInputError(tag: 1)
            return
        }
        //英語(ローマ字)オッケ？
        if myTextFields[2].text?.isOnlyAlphabet == false || myTextFields[2].text == ""{
            //showAlert()
            print("out2")
            showAlertInputError(tag: 2)
            return
        }
        if myTextFields[3].text?.isOnlyAlphabet == false || myTextFields[3].text == ""{
            print("out3")
            showAlertInputError(tag: 3)
            return
        }
        //ナンバーおけ？
        if myTextFields[4].text?.isOnlyNumber == false || myTextFields[4].text == ""{
            //showAlert
            print("out4")
            showAlertInputError(tag: 4)
            return
        }
        //入団年おけ？
        if myTextFields[5].text?.isOnlyNumber == false || myTextFields[5].text == ""{
            //showAlert
            print("out5")
            showAlertInputError(tag: 5)
            return
        }
       
        if let playerrealm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: playerId){
            playerrealm.update {
                print("updated!")
                playerrealm.last_name = myTextFields[0].text!
                playerrealm.first_name = myTextFields[1].text!
                playerrealm.last_name_eng = myTextFields[2].text!
                playerrealm.first_name_eng = myTextFields[3].text!
                playerrealm.number = myTextFields[4].text!
                playerrealm.admission_year = Int(myTextFields[5].text!)!
            }
        }
        for textfield in myTextFields{
            textfield.text = ""
        }
        addButton.titleLabel?.text = "追加"
        addButton.removeTarget(self, action: #selector(self.endEditPlayer(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.addPlayer(_:)), for: .touchUpInside)
        //現役選手がいるかどうかチェック
        showPlayerList()
        
    }
    
    func retirePlayer(_ sender:UIButton){
       
        if let playerrealm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: playerId){
            playerrealm.update {
                playerrealm.isRetired = !playerrealm.isRetired
            }
            showPlayerProfile(id: playerId)
            checkNoPlayer()
        }
        
    }
    
    func rebornPlayer(_ sender:UIButton){
    
    }
    
    func deletePlayer(_ sender:UIButton){
        //本当に消しますかのAlert表示
        showAlertDelete()
        //消す作業
        print("delete")
        //showPlayerList()
        //checkNoPlayer()
    }
    
    func showPlayerList(){
        
        if !yearSet.isEmpty{
            //一旦空にする
            //全部消す
            for label in yearSet{
                playerListStack.removeArrangedSubview(label)
            }
            yearSet.removeAll()
        }
        
        if !playerList.isEmpty{
            //一旦空にする
            //全部消す
            for substack in playerList{
                playerListStack.removeArrangedSubview(substack.value.1)
            }
            playerList.removeAll()
        }
        
        var year = 9999
        //入団年順(降順)，アルファベット順で読み込み
        let results = PlayerRealm.loadAll()
        print(results)
        
        for player in results{
            if year > player.admission_year {
                year = player.admission_year
                let yearLabel = UILabel()
                yearLabel.text = String(year) + "年"
                playerListStack.addArrangedSubview(yearLabel)
                yearSet.insert(yearLabel)
            }
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
        if prePlayerLabel != playerlist?.0{
            playerlist?.0.backgroundColor = UIColor.flatSkyBlue()
            prePlayerLabel.backgroundColor = UIColor.flatWhite()
            prePlayerLabel = (playerlist?.0)!
        }
        //print("okok")
        showPlayerProfile(id: playerId)
    }
    
    func showPlayerProfile(id:Int){
        if let playerrealm = PlayerRealm.realm.object(ofType: PlayerRealm.self, forPrimaryKey: id){
            nameLabel_jpn.text = playerrealm.last_name + " " + playerrealm.first_name
            nameLabel_eng.text = playerrealm.last_name_eng + " " + playerrealm.first_name_eng
            numberLabel.text = "#"+playerrealm.number
            yearLabel.text = String(playerrealm.admission_year)
            if playerrealm.isRetired == false{
                retireLabel.text = "現役"
            }else{
                retireLabel.text = "OB・OG"
            }
        }
    }
    
    func checkNoPlayer() {
        let predicate = NSPredicate(format:"isRetired == FALSE")
        let results = PlayerRealm.realm.objects(PlayerRealm.self).filter(predicate)
        //print(results)
        if results.count == 0{
            //現役選手がいない状態
            showAlertNoPlayer()
        }
    }
    
    func showAlertInputError(tag:Int){
        var msg = ""
        switch tag {
        case 0:
            //苗字
            msg = "苗字を入力してください"
        case 1:
            msg = "名前を入力してください"
        case 2:
            msg = "苗字(ローマ字)を入力してください"
        case 3:
            msg = "名前(ローマ字)を入力してください"
        case 4:
            msg = "#背番号を入力してください"
        case 5:
            msg = "入団年を入力してください"
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
        
        
        
        // キャンセルボタンの設定
        /*
         let cancelAction = UIAlertAction(title: "戻る", style: .cancel, handler: {
         (action:UIAlertAction!) -> Void in
         self.dismiss(animated: true, completion: nil)
         })
         alert.addAction(cancelAction)
         */
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertNoPlayer() {
        
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "現役の選手がいません", message: "プレイヤー情報を入力しましょう", preferredStyle: .alert)
        // OKボタンの設定
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
        })
        alert.addAction(okAction)
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDelete() {
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "本当にこの選手を消去しますか？", message: "この選手の成績の全てが消去されます", preferredStyle: .alert)
        // OKボタンの設定
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            //ScoreRealmから該当のデータを検索し，全てを消去
            print("start")
            ScoreRealm.delete(player: self.playerId)
            print("score")
            
            //該当するプレイヤーを消去
            PlayerRealm.delete(player: self.playerId)
            
            self.showPlayerList()
            self.checkNoPlayer()
        })
        alert.addAction(okAction)
        
        
        
        // キャンセルボタンの設定
        
         let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
         (action:UIAlertAction!) -> Void in
         //self.dismiss(animated: true, completion: nil)
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

extension String {
    
    public func isOnly(structuredBy chars: String) -> Bool {
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: chars)
        return self.trimmingCharacters(in: characterSet as CharacterSet).characters.count <= 0
    }
    /// 数字
    public static let structureOfNumber = "0123456789"
    
    /// 小英字
    public static let structureOfLowercaseAlphabet = "abcdefghijklmnopqrstuvwxyz"
    
    /// 大英字
    public static let structureOfUppercaseAlphabet = structureOfLowercaseAlphabet.uppercased()
    
    /// 英字
    public static let structureOfAlphabet = structureOfLowercaseAlphabet + structureOfUppercaseAlphabet
    
    /// 英数字
    public static let structureOfAlphabetAndNumber = structureOfAlphabet + structureOfNumber
    
    /// 半角数字のみで構成されているかどうか
    public var isOnlyNumber: Bool {
        let chars = String.structureOfNumber
        return self.isOnly(structuredBy: chars)
    }
    
    /// 半角アルファベットのみで構成されているかどうか
    public var isOnlyAlphabet: Bool {
        let chars = String.structureOfAlphabet
        return self.isOnly(structuredBy: chars)
    }
    
    /// 半角英数字のみで構成されているかどうか
    public var isOnlyAlphabetAndNumber: Bool {
        let chars = String.structureOfAlphabetAndNumber
        return self.isOnly(structuredBy: chars)
    }
}

