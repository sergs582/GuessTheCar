//
//  GameOverViewController.swift
//  GuessTheCar
//
//  Created by сергей on 17/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameOverViewController: UIViewController, GADRewardBasedVideoAdDelegate {
 

    
  
    var Sound : Bool = true
    var cars : Int = 0
    var score : Int = 0
    
    
    @IBOutlet weak var carsGuessed: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var RestartBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carsGuessed.text = String(cars)
        scoreLabel.text = String(score)
        
        BackBtn.corners()
        RestartBtn.corners()
        
        
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                        withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        
      
    }
    
  
    
    @IBAction func BackToMenu(_ sender: Any) {
        if GADRewardBasedVideoAd.sharedInstance().isReady{
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }else{
          performSegue(withIdentifier: "BackToMenu", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToMenu"{
            
        
        let MenuVC = segue.destination as! ViewController
        MenuVC.Sound = Sound
        }else if segue.identifier == "Restart"{
        let GameVC = segue.destination as! GameProcessViewController
        GameVC.Sound = Sound
        }
    }
    @IBAction func Restart(_ sender: Any) {
        performSegue(withIdentifier: "Restart", sender: self)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        performSegue(withIdentifier: "Restart", sender: self)
    }
    
    
}


extension UIButton{
    
    func corners(){
        self.layer.cornerRadius = 5
    }
    
}
