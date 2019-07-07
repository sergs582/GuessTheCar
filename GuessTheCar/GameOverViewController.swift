//
//  GameOverViewController.swift
//  GuessTheCar
//
//  Created by сергей on 17/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameOverViewController: UIViewController, GADInterstitialDelegate {
 

    
  
    var Sound : Bool = true
    var cars : Int = 0
    var score : Int = 0
    
    var interstitial: GADInterstitial!
    
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
        
        Sound = Preferences().getSoundState()
       
        interstitial = createAndLoadInterstitial()
        
    }
    
    func createAndLoadInterstitial()->GADInterstitial{
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        performSegue(withIdentifier: "Restart", sender: self)
    }
  
    
    @IBAction func BackToMenu(_ sender: Any) {
        
          performSegue(withIdentifier: "BackToMenu", sender: self)
        
        
    }
    @IBAction func Restart(_ sender: Any) {
        if interstitial.isReady{
           interstitial.present(fromRootViewController: self)
        }else{
        performSegue(withIdentifier: "Restart", sender: self)
        }
    }
    
   
    
    
}


extension UIButton{
    
    func corners(){
        self.layer.cornerRadius = self.bounds.height/2
    }
    
}
