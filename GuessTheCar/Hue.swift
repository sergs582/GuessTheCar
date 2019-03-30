

import UIKit

class Hue: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var savetext: UITextField!
    @IBOutlet weak var readtext: UITextField!
    
  
    var s = 1
    var r = 0
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
       
    }
    
    
    @IBAction func echa(_ sender: Any) {
        label.text = savetext.text
    
    }
    
    @IBAction func savebtn(_ sender: Any) {
        ScoresAPI().SaveNewScore(score: savetext.text!, k: s)
        
        s += 1
        if s == 5{
            s = 1
        }
        
    }
    
    @IBAction func readbtn(_ sender: Any) {
        label.text = ScoresAPI().GetScoresList()[r]
        r += 1
        if r == 5{
            r = 0
        }
    }
    
}
