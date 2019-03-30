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
    var ScoresArray : [String] = [String]()
    
    @IBOutlet weak var Score1: UILabel!
    @IBOutlet weak var Score2: UILabel!
    @IBOutlet weak var Score3: UILabel!
    @IBOutlet weak var Score4: UILabel!
    @IBOutlet weak var Score5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoresArray = ScoresAPI().GetScoresList()
        
        Score1.text = ScoresArray[0]
        Score2.text = ScoresArray[1]
        Score3.text = ScoresArray[2]
        Score4.text = ScoresArray[3]
        Score5.text = ScoresArray[4]
        
        
    }
    

}
