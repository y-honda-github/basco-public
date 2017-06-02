//
//  SecondViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/09.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    struct shootRate {
        var numOfIn:Int
        var numOfTotal:Int
        
        init (numofin:Int, numoftotal:Int){
            self.numOfIn = numofin
            self.numOfTotal = numoftotal
        }
    }
    
    var startPoint : CGPoint!
    
    @IBOutlet weak var playerPickerView: UIPickerView!
    
    @IBOutlet weak var startDatePicker1: UIDatePicker!
    @IBOutlet weak var endDatePicker1: UIDatePicker!
    @IBOutlet weak var compePickerView1: UIPickerView!
    @IBOutlet weak var gamePickerView1: UIPickerView!
    @IBOutlet weak var scenePickerView1: UIPickerView!
    @IBOutlet var shootPlaceLabel1: [UILabel]!
    @IBOutlet weak var showButton1: UIButton!
    @IBOutlet weak var officialButton1: UIButton!
    @IBOutlet weak var practicegameButton1: UIButton!
    @IBOutlet weak var practiceButton1: UIButton!
    
    
    
    
    @IBOutlet weak var startDatePicker2: UIDatePicker!
    @IBOutlet weak var endDatePicker2: UIDatePicker!
    @IBOutlet weak var compePickerView2: UIPickerView!
    @IBOutlet weak var gamePickerView2: UIPickerView!
    @IBOutlet weak var scenePickerView2: UIPickerView!
    @IBOutlet var shootPlaceLabels2: [UILabel]!
    @IBOutlet weak var showButton2: UIButton!
    @IBOutlet weak var officialButton2: UIButton!
    @IBOutlet weak var practicegameButton2: UIButton!
    @IBOutlet weak var practiceButton2: UIButton!
    
    
  
    var compoPlayer:[[(String,Int)]] = [[("プレイヤー選択",-1)]]
    
    var compoCompetitions1:[[String]] = [[]]
    var compoGame1:[[(String,Int,String)]] = [[]]
    var compoScene1 = [["全て","前半","後半","第1Q","第2Q","第3Q","第4Q"]]
    var ScoreTable1 = [shootRate](repeating:shootRate(numofin:0, numoftotal:0), count:16)
    
    var compoCompetitions2:[[String]] = [[]]
    var compoGame2:[[(String,Int,String)]] = [[]]
    var compoScene2 = [["全て","前半","後半","第1Q","第2Q","第3Q","第4Q"]]
    var ScoreTable2 = [shootRate](repeating:shootRate(numofin:0, numoftotal:0), count:16)
    var count = 0
    
    //コンポーネントの数を返す
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        var compNum:Int
        switch pickerView {
        case playerPickerView:
            compNum = compoPlayer.count
        case compePickerView1:
            compNum = compoCompetitions1.count
        case gamePickerView1:
            compNum = compoGame1.count
        case scenePickerView1:
            compNum = compoScene1.count
        case compePickerView2:
            compNum = compoCompetitions2.count
        case gamePickerView2:
            compNum = compoGame2.count
        case scenePickerView2:
            compNum = compoScene2.count
        default:
            compNum = -1
        }
        return compNum
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rowNum:Int
        switch pickerView {
        case playerPickerView:
            rowNum = compoPlayer[component].count
        case compePickerView1:
            rowNum = compoCompetitions1[component].count
        case gamePickerView1:
            rowNum = compoGame1[component].count
        case scenePickerView1:
            rowNum = compoScene1[component].count
        case compePickerView2:
            rowNum = compoCompetitions2[component].count
        case gamePickerView2:
            rowNum = compoGame2[component].count
        case scenePickerView2:
            rowNum = compoScene2[component].count
        default:
            rowNum = -1
        }
        return rowNum
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item:String
        if(pickerView == compePickerView2){
            print("uooooo")
        }
        switch pickerView {
        case playerPickerView:
            item = compoPlayer[component][row].0
        case compePickerView1:
            item = compoCompetitions1[component][row]
        case gamePickerView1:
            item = compoGame1[component][row].0
        case scenePickerView1:
            item = compoScene1[component][row]
        case compePickerView2:
            item = compoCompetitions2[component][row]
        case gamePickerView2:
            item = compoGame2[component][row].0
        case scenePickerView2:
            item = compoScene2[component][row]
        default:
            item = ""
        }
        return item
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var item:String
        switch pickerView {
        case playerPickerView:
            item = compoPlayer[component][row].0
            checkShow()
            //button
        case compePickerView1:
            item = compoCompetitions1[component][row]
            compoGame1 = narrowGame(start: startDatePicker1.date,end: endDatePicker1.date, oppopent: item,official: officialButton1,practicegame: practicegameButton1,practice: practiceButton1)
            gamePickerView1.dataSource = self
            gamePickerView1.selectRow(0, inComponent: 0, animated: false)
        case gamePickerView1:
            item = compoGame1[component][row].0
        case scenePickerView1:
            item = compoScene1[component][row]
        case compePickerView2:
            item = compoCompetitions2[component][row]
            compoGame2 = narrowGame(start: startDatePicker2.date,end: endDatePicker2.date, oppopent: item,official: officialButton2,practicegame: practicegameButton2,practice: practiceButton2)
            gamePickerView2.dataSource = self
            gamePickerView1.selectRow(0, inComponent: 0, animated: false)
        case gamePickerView2:
            item = compoGame2[component][row].0
        case scenePickerView2:
            item = compoScene2[component][row]
        default:
            item = ""
        }
        print("\(item)が選ばれた")
        
        //現在選択されている行番号
        let row1 = pickerView.selectedRow(inComponent: 0)
        print("現在選択されている行番号\(row1)")
        
        //現在選択されている項目名
        let item1 = self.pickerView(pickerView, titleForRow: row1, forComponent: 0)
        print("現在選択されている項目名\(item1!)")
        print("-------------------")
        switch pickerView {
        case playerPickerView:
            break
        case compePickerView2:
            compePickerView2.dataSource = self
        case gamePickerView2:
            gamePickerView2.dataSource = self
        case scenePickerView2:
            print("")
            //compoScene2[component].append("taro\(count)")
            //scenePickerView2.dataSource = self
        default:
            item = ""
        }
        count += 1
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
            switch sender{
            case startDatePicker1, endDatePicker1:
                endDatePicker1.minimumDate = startDatePicker1.date
                (compoCompetitions1,compoGame1) = searchGame(start: startDatePicker1.date,end: endDatePicker1.date,official: officialButton1,practicegame: practicegameButton1,practice: practiceButton1)
                compePickerView1.dataSource = self
                gamePickerView1.dataSource = self
                compePickerView1.selectRow(0, inComponent: 0, animated: false)
                gamePickerView1.selectRow(0, inComponent: 0, animated: false)
            case startDatePicker2, endDatePicker2:
                endDatePicker2.minimumDate = startDatePicker2.date
                (compoCompetitions2,compoGame2) = searchGame(start: startDatePicker2.date,end: endDatePicker2.date,official: officialButton2,practicegame: practicegameButton2,practice: practiceButton2)
                compePickerView2.dataSource = self
                gamePickerView2.dataSource = self
                compePickerView2.selectRow(0, inComponent: 0, animated: false)
                gamePickerView2.selectRow(0, inComponent: 0, animated: false)
            default:
                break
            }
        }
        checkShow()
    }
    
    /*
    func compeChanged(_ sender: UIPickerView){
        switch sender {
        case compePickerView1:
            compoGame1 = narrowGame(oppopent: compoCompetitions1[0][compePickerView1.selectedRow(inComponent: 0)])
            gamePickerView1.dataSource = self
        case compePickerView2:
            compoGame2 = narrowGame(oppopent: compoCompetitions2[0][compePickerView2.selectedRow(inComponent: 0)])
            gamePickerView2.dataSource = self
        default:
            break
        }
    }
    */
    func showTable(_ sender:UIButton){
        
        //プレイヤーが何か
        let playerid = compoPlayer[0][playerPickerView.selectedRow(inComponent: 0)].1
        
        
        if sender == showButton1{
            //押されたのがshowButton1の時
            //試合はどれか
            var games:[Int] = []
            if compoGame1[0][gamePickerView1.selectedRow(inComponent: 0)].1 == 0{
                for game in compoGame1[0]{
                    if game.1 != 0{
                        games.append(game.1)
                    }
                }
            }else{
                games.append(compoGame1[0][gamePickerView1.selectedRow(inComponent: 0)].1)
            }
            //シーンを絞る
            var quarters:[Int] = []
            //"全て","前半","後半","第1Q","第2Q","第3Q","第4Q"
            switch compoScene1[0][scenePickerView1.selectedRow(inComponent: 0)] {
            case "全て": quarters = [1,2,3,4]
            case "前半": quarters = [1,2]
            case "後半": quarters = [3,4]
            case "第1Q": quarters = [1]
            case "第2Q": quarters = [2]
            case "第3Q": quarters = [3]
            case "第4Q": quarters = [4]
            default:
                break
            }
            if compoGame1[0][gamePickerView1.selectedRow(inComponent: 0)].1 == 0{
                for game in compoGame1[0]{
                    if game.1 != 0{
                        games.append(game.1)
                    }
                }
            }else{
                games.append(compoGame1[0][gamePickerView1.selectedRow(inComponent: 0)].1)
                
            }
            print(games)
            //scoreを絞る
            let predicate = NSPredicate.empty
                .and(predicate: NSPredicate("player_id",equal:playerid as AnyObject))
                .and(predicate: NSPredicate("game_id", valuesIn: games as [AnyObject]))
                .and(predicate: NSPredicate("quarter", valuesIn: quarters as[AnyObject]))
            let results = ScoreRealm.realm.objects(ScoreRealm.self).filter(predicate)
            print(results)
            //表示
            ScoreTable1 = [shootRate](repeating:shootRate(numofin:0, numoftotal:0), count:16)
            for score in results{
                ScoreTable1[score.shoot_place].numOfTotal += 1
                if score.isIn == true{
                    ScoreTable1[score.shoot_place].numOfIn += 1
                }
            }
            for shootplace in 0...15{
                if ScoreTable1[shootplace].numOfTotal != 0{
                    let pro = round(Double(ScoreTable1[shootplace].numOfIn) / Double(ScoreTable1[shootplace].numOfTotal) * 1000.0) / 10.0
                    shootPlaceLabel1[shootplace].text = String(pro) + "%\n(" + String(ScoreTable1[shootplace].numOfIn) + "/" + String(ScoreTable1[shootplace].numOfTotal) + ")"
                }else{
                    shootPlaceLabel1[shootplace].text = "-"
                }
            }
        }else if sender == showButton2{
            //押されたのがshowButton1の時
            //試合はどれか
            var games:[Int] = []
            if compoGame2[0][gamePickerView2.selectedRow(inComponent: 0)].1 == 0{
                for game in compoGame2[0]{
                    if game.1 != 0{
                        games.append(game.1)
                    }
                }
            }else{
                games.append(compoGame2[0][gamePickerView2.selectedRow(inComponent: 0)].1)
            }
            //シーンを絞る
            var quarters:[Int] = []
            //"全て","前半","後半","第1Q","第2Q","第3Q","第4Q"
            switch compoScene2[0][scenePickerView2.selectedRow(inComponent: 0)] {
            case "全て": quarters = [1,2,3,4]
            case "前半": quarters = [1,2]
            case "後半": quarters = [3,4]
            case "第1Q": quarters = [1]
            case "第2Q": quarters = [2]
            case "第3Q": quarters = [3]
            case "第4Q": quarters = [4]
            default:
                break
            }
            if compoGame2[0][gamePickerView2.selectedRow(inComponent: 0)].1 == 0{
                for game in compoGame1[0]{
                    if game.1 != 0{
                        games.append(game.1)
                    }
                }
            }else{
                games.append(compoGame2[0][gamePickerView2.selectedRow(inComponent: 0)].1)
            }
            //scoreを絞る
            let predicate = NSPredicate.empty
                .and(predicate: NSPredicate("player_id",equal:playerid as AnyObject))
                .and(predicate: NSPredicate("game_id", valuesIn: games as [AnyObject]))
                .and(predicate: NSPredicate("quarter", valuesIn: quarters as[AnyObject]))
            let results = ScoreRealm.realm.objects(ScoreRealm.self).filter(predicate)
            print(results)
            //表示
            ScoreTable2 = [shootRate](repeating:shootRate(numofin:0, numoftotal:0), count:16)
            for score in results{
                ScoreTable2[score.shoot_place].numOfTotal += 1
                if score.isIn == true{
                    ScoreTable2[score.shoot_place].numOfIn += 1
                }
            }
            for shootplace in 0...15{
                if ScoreTable2[shootplace].numOfTotal != 0{
                    let pro = round(Double(ScoreTable2[shootplace].numOfIn) / Double(ScoreTable2[shootplace].numOfTotal) * 1000.0) / 10.0
                    shootPlaceLabels2[shootplace].text = String(pro) + "%\n(" + String(ScoreTable2[shootplace].numOfIn) + "/" + String(ScoreTable2[shootplace].numOfTotal) + ")"
                }else{
                    shootPlaceLabel1[shootplace].text = "-"
                }
            }
        }else{
            
        }
    }
    
    func searchGame(start:Date,end:Date,official:UIButton, practicegame:UIButton,practice:UIButton ) -> ([[String]],[[(String,Int,String)]]){
        var compoCompetition:[[String]] = [[]]
        var compoGame:[[(String,Int,String)]] = [[]]
        var predicate_official:NSPredicate
        var predicate_practicegame:NSPredicate
        var predicate_practice:NSPredicate
        if official.backgroundColor == UIColor.flatSkyBlue(){
            predicate_official = NSPredicate("game_type",equal:1 as AnyObject)
        }else{
            predicate_official = NSPredicate("game_type",equal:0 as AnyObject)
        }
        if practicegame.backgroundColor == UIColor.flatSkyBlue(){
            predicate_practicegame = NSPredicate("game_type",equal:2 as AnyObject)
        }else{
            predicate_practicegame = NSPredicate("game_type",equal:0 as AnyObject)
        }
        if practice.backgroundColor == UIColor.flatSkyBlue(){
            predicate_practice = NSPredicate("game_type",equal:3 as AnyObject)
        }else{
            predicate_practice = NSPredicate("game_type",equal:0 as AnyObject)
        }
        let predicate = NSPredicate.empty
            .and(predicate: NSPredicate("day",fromDate:start as NSDate,toDate:end as NSDate))
            .and(predicate: predicate_official.or(predicate: predicate_practicegame.or(predicate: predicate_practice)))
        let results = GameRealm.realm.objects(GameRealm.self).filter(predicate)
        
        if results.count != 0{
            compoCompetition[0].append("全て")
            compoGame[0].append(("全て",0,"全て"))
        }
        
        for game in results{
            if !compoCompetition[0].contains(game.opponent){
                compoCompetition[0].append(game.opponent)
            }
            compoGame[0].append((game.title,game.id,game.opponent))
        }
        print(compoCompetition)
        return(compoCompetition,compoGame)
    }
    
    func narrowGame(start:Date,end:Date,oppopent: String,official:UIButton, practicegame:UIButton,practice:UIButton ) -> [[(String,Int,String)]]{
        var compoGame:[[(String,Int,String)]] = [[("全て",0,"全て")]]
        var predicate_official:NSPredicate
        var predicate_practicegame:NSPredicate
        var predicate_practice:NSPredicate
        if official.backgroundColor == UIColor.flatSkyBlue(){
            predicate_official = NSPredicate("game_type",equal:1 as AnyObject)
        }else{
            predicate_official = NSPredicate("game_type",equal:0 as AnyObject)
        }
        if practicegame.backgroundColor == UIColor.flatSkyBlue(){
            predicate_practicegame = NSPredicate("game_type",equal:2 as AnyObject)
        }else{
            predicate_practicegame = NSPredicate("game_type",equal:0 as AnyObject)
        }
        if practice.backgroundColor == UIColor.flatSkyBlue(){
            predicate_practice = NSPredicate("game_type",equal:3 as AnyObject)
        }else{
            predicate_practice = NSPredicate("game_type",equal:0 as AnyObject)
        }
        let predicate = NSPredicate.empty
            .and(predicate: NSPredicate("day",fromDate:start as NSDate,toDate:end as NSDate))
            .and(predicate: predicate_official.or(predicate: predicate_practicegame.or(predicate: predicate_practice)))
        let results = GameRealm.realm.objects(GameRealm.self).filter(predicate)
        for result in results{
            if oppopent == "全て"{
                compoGame[0].append((result.title,result.id,result.opponent))
            }else{
                if result.opponent == oppopent{
                    compoGame[0].append((result.title,result.id,result.opponent))
                }
            }
        }
        return compoGame
    }
    
    func checkShow(){
        if playerPickerView.selectedRow(inComponent: 0) == 0{
            showButton1.isEnabled = false
            showButton2.isEnabled = false
            return
        }else{
            if officialButton1.backgroundColor == UIColor.flatSkyBlue() || practicegameButton1.backgroundColor == UIColor.flatSkyBlue() || practiceButton1.backgroundColor == UIColor.flatSkyBlue(){
                showButton1.isEnabled = true
                showButton2.isEnabled = true
            }else{
                showButton1.isEnabled = false
                showButton2.isEnabled = false
            }
        }
        if compoCompetitions1[0].count == 0{
            showButton1.isEnabled = false
        }else{
            showButton1.isEnabled = true
        }
        if compoCompetitions2[0].count == 0{
            showButton2.isEnabled = false
        }else{
            showButton2.isEnabled = true
        }
    }
    
    func changeKindButtonColor(_ sender:UIButton){
        if sender.backgroundColor == UIColor.flatSkyBlue(){
            sender.backgroundColor = UIColor.clear
            sender.tintColor = UIColor.flatBlack()
        }else{
            sender.backgroundColor = UIColor.flatSkyBlue()
            sender.tintColor = UIColor.flatWhite()
        }
        switch  sender {
        case officialButton1, practicegameButton1, practiceButton1:
            (compoCompetitions1,compoGame1) = searchGame(start: startDatePicker1.date,end: endDatePicker1.date,official: officialButton1,practicegame: practicegameButton1,practice: practiceButton1)
            compePickerView1.dataSource = self
            gamePickerView1.dataSource = self
            compePickerView1.selectRow(0, inComponent: 0, animated: false)
            gamePickerView1.selectRow(0, inComponent: 0, animated: false)
        case officialButton2, practicegameButton2, practiceButton2:
            (compoCompetitions2,compoGame2) = searchGame(start: startDatePicker2.date,end: endDatePicker2.date,official: officialButton2,practicegame: practicegameButton2,practice: practiceButton2)
            compePickerView2.dataSource = self
            gamePickerView2.dataSource = self
            compePickerView2.selectRow(0, inComponent: 0, animated: false)
            gamePickerView2.selectRow(0, inComponent: 0, animated: false)
        default:
            break
        }
        checkShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("個人成績登場")
        compoPlayer[0].removeAll()
        compoPlayer[0].append(("プレイヤー選択",-1))
        let predicate = NSPredicate(format:"isRetired == FALSE")
        let results = PlayerRealm.realm.objects(PlayerRealm.self).filter(predicate)
        for player in results{
            self.compoPlayer[0].append((player.last_name + " " + player.first_name,player.id))
        }
        
        playerPickerView.delegate = self
        playerPickerView.dataSource = self
        compePickerView1.delegate = self
        compePickerView1.dataSource = self
        gamePickerView1.delegate = self
        gamePickerView1.dataSource = self
        scenePickerView1.delegate = self
        scenePickerView1.dataSource = self
        startDatePicker1.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startDatePicker1.maximumDate = Date()
        endDatePicker1.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        endDatePicker1.maximumDate = Date()
        endDatePicker1.minimumDate = startDatePicker1.date
        showButton1.addTarget(self, action: #selector(showTable(_:)), for: .touchUpInside)
        
        compePickerView2.delegate = self
        compePickerView2.dataSource = self
        gamePickerView2.delegate = self
        gamePickerView2.dataSource = self
        scenePickerView2.delegate = self
        scenePickerView2.dataSource = self
        startDatePicker2.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startDatePicker2.maximumDate = Date()
        endDatePicker2.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        endDatePicker2.maximumDate = Date()
        endDatePicker2.minimumDate = startDatePicker2.date
        showButton2.addTarget(self, action: #selector(showTable(_:)), for: .touchUpInside)
        //ゲームの種類ラベルをタップで色を変化させる
        officialButton1.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        practicegameButton1.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        practiceButton1.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        officialButton2.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        practicegameButton2.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        practiceButton2.addTarget(self, action: #selector(self.changeKindButtonColor(_:)), for: .touchUpInside)
        
        checkShow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let list = GameRealm.loadAll()
        print(list)
        
        let scores = ScoreRealm.loadAll()
        print(scores)
        //print("個人成績登場")
        // Do any additional setup after loading the view.
        //プレイヤー読み込み
        
        
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

extension SecondViewController: UIScrollViewDelegate{
    
    // ドラッグ開始時のスクロール位置記憶
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startPoint = scrollView.contentOffset
    }
    
    // ドラッグ(スクロール)しても y 座標は開始時から動かないようにする(固定)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = self.startPoint.x
    }
}
