//
//  ScoresViewController.swift
//  GuessTheCar
//
//  Created by сергей on 24/03/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController {
 
    var Sound : Bool = true
    var ScoresArray : [Int] = [Int]()
    var CarsArray : [Int] = [Int]()
    
    @IBOutlet weak var Score1: UILabel!
    @IBOutlet weak var Score2: UILabel!
    @IBOutlet weak var Score3: UILabel!
    @IBOutlet weak var Score4: UILabel!
    @IBOutlet weak var Score5: UILabel!
    @IBOutlet weak var Cars1: UILabel!
    @IBOutlet weak var Cars2: UILabel!
    @IBOutlet weak var Cars3: UILabel!
    @IBOutlet weak var Cars4: UILabel!
    @IBOutlet weak var Cars5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ScLabelArray = [Score1, Score2, Score3, Score4, Score5]
        var CarLabelArray = [Cars1, Cars2, Cars3, Cars4, Cars5]
       
        ScoresArray = ScoresAPI().GetScoresList()
        CarsArray = ScoresAPI().GetCarsList()
        
        ScoresArray.sort()
        ScoresArray.reverse()
        CarsArray.sort()
        CarsArray.reverse()
        
        
        for (i, Score) in ScoresArray.enumerated(){
            ScLabelArray[i]!.text = String(Score)
            CarLabelArray[i]!.text = String(CarsArray[i])
        }
        
    }
}
