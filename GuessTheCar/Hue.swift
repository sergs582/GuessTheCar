

import UIKit

class Hue: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var savetext: UITextField!
    @IBOutlet weak var readtext: UITextField!
    @IBOutlet var swipe: UISwipeGestureRecognizer!
    
  
    var s = 1
    var r = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        swipe = UISwipeGestureRecognizer(target: self, action: #selector(test(sender:)))
        self.view.addGestureRecognizer(swipe)
        self.view.draw(CGRect(x: 40, y: 40, width: 10, height: 10))
        //let arr = readPlist(name: "AppTests")!
       // print(arr.randomElement())
        //print(arr["BMW"]![1])
        
        
        
    }
    @objc func test(sender: UISwipeGestureRecognizer){
        label.text = "Swiped"
    }
    
    @IBAction func echa(_ sender: Any) {
        label.text = savetext.text
    
    }
    
    
    func readPlist(name: String)->[String:[String]]?{
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let CarsList = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: CarsList, options: .mutableContainers, format: nil)) as? [String:[String]]
        }else{
            return nil
        }
        
    }
    
    @IBAction func savebtn(_ sender: Any) {
        //ScoresAPI().SaveNewScore(score: savetext.text!, k: s)
        
        s += 1
        if s == 5{
            s = 1
        }
        
    }
    
    @IBAction func readbtn(_ sender: Any) {
      //  label.text = ScoresAPI().GetScoresList()[r]
        r += 1
        if r == 5{
            r = 0
        }
    }
    
}
