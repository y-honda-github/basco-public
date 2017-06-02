//
//  StartViewController.swift
//  BasketBallScore
//
//  Created by 本田美輝 on 2017/03/09.
//  Copyright © 2017年 Yoshiki Honda. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let start = Date()
        while (Date().timeIntervalSince(start) < 1.0){
            print(Date().timeIntervalSince(start))
        }
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPage")
        nextVC?.modalTransitionStyle = .crossDissolve
        present(nextVC! , animated: true, completion: nil)
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
