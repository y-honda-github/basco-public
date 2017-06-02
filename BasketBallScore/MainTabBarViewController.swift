//
//  MainTabBarViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/23.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //レンダリングモードをAlwaysOriginalでボタンの画像を登録する。
        tabBar.items![0].image = UIImage(named: "home_unselected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        tabBar.items![1].image = UIImage(named: "playerdata_unselected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        tabBar.items![2].image = UIImage(named: "ranking_unselected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        
        //選択中のアイテムの画像はレンダリングモードを指定しない。
        tabBar.items![0].selectedImage = UIImage(named: "home_selected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        tabBar.items![1].selectedImage = UIImage(named: "playerdata_selected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        tabBar.items![2].selectedImage = UIImage(named: "ranking_selected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        tabBar.tintColor = UIColor.init(red: 153/255, green: 0, blue: 0, alpha: 1)
                // Do any additional setup after loading the view.
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
