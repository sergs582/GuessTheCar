//
//  GameOverViewController.swift
//  GuessTheCar
//
//  Created by сергей on 17/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    
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
    }
    
    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "BackToMenu", sender: self)
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
    
}


extension UIButton{
    
    func corners(){
        print("hi")
        self.layer.cornerRadius = 5
    }
    
}
