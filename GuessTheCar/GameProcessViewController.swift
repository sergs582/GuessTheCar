//
//  GameProcessViewController.swift
//  GuessTheCar
//
//  Created by сергей on 02/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class GameProcessViewController: UIViewController, GADBannerViewDelegate {

    //Кнопки
    @IBOutlet weak var FirstVariant: UIButton!
    @IBOutlet weak var SecondVariant: UIButton!
    @IBOutlet weak var ThirdVariant: UIButton!
    @IBOutlet weak var FourthVariant: UIButton!
    @IBOutlet weak var Pause: UIButton!
    @IBOutlet weak var Help: UIButton!
    @IBOutlet weak var HintButton: UIButton!
    @IBOutlet weak var ExtraTime: UIButton!
    @IBOutlet weak var SkipButton: UIButton!
    @IBOutlet weak var ContinueBtn: UIButton!
    @IBOutlet weak var MainMenuBtn: UIButton!
    @IBOutlet weak var SoundBtn: UIButton!
    
    @IBOutlet weak var timeProgress: UIProgressView!
    
    @IBOutlet weak var AdBanner: GADBannerView!
    @IBOutlet weak var AdBannerHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var scores: UILabel!
    @IBOutlet weak var carsGuessed: UILabel!
    @IBOutlet weak var carsGuessed_PauseMenu: UILabel!
    
    @IBOutlet weak var CarImage: UIImageView!
    @IBOutlet weak var HealthImage: UIImageView!
    @IBOutlet weak var Health_PauseMenu: UIImageView!
    @IBOutlet weak var Score_PauseMenu: UILabel!
    
    var timer = Timer()
    var scoreTimer = Timer()
    var UpdTimer = Timer()
    var showHealth = Timer()
    var closeHelp = Timer()
    
    var score : Int = 0
    var seconds : Int = 0
    var cars : Int = 0
    var health : Int = 3
    
    var Sound : Bool = true
    
    var randomNum: Int = 0
    var randomHintNumber: Int = 0
    
    var UnusedCars : [String:[String]] = [String:[String]]()
    var VariantsForButtons : [String:[String]] = [String:[String]]()
    var CarNamesArray : [String] = [String]()
    var CarName : String = ""
    
    var CurrentCar : String = ""
    var titleButton : String = ""
    
    var HornSound : AVAudioPlayer = AVAudioPlayer()
    var WrongAnswer : AVAudioPlayer = AVAudioPlayer()
    var CorrectAnswer : AVAudioPlayer = AVAudioPlayer()
    
    var VariantsButtonsArray: [UIButton] = [UIButton]()
    
    @IBOutlet weak var PauseMenu: UIView!
    @IBOutlet weak var ButtonsView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Loading Ads
        AdBanner.delegate = self
        AdBanner.adSize = kGADAdSizeSmartBannerPortrait
        AdBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        AdBanner.isHidden = true
        AdBanner.rootViewController = self
        AdBanner.load(GADRequest())
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")//Loading Ad to use in GameOverVC
    
        FirstVariant.isExclusiveTouch = true
      SecondVariant.isExclusiveTouch = true
        ThirdVariant.isExclusiveTouch = true
       FourthVariant.isExclusiveTouch = true
        
        CarNamesArray = readPlist(name: "Cars")!
        UnusedCars = readPlist2(name: "CarsList")!
        VariantsForButtons = readPlist2(name: "CarsVariants")!
        
        VariantsButtonsArray = [FirstVariant,SecondVariant,ThirdVariant,FourthVariant]

        FirstVariant.customCorner()
        SecondVariant.customCorner()
        ThirdVariant.customCorner()
        FourthVariant.customCorner()
        ContinueBtn.layer.cornerRadius = 7
        MainMenuBtn.layer.cornerRadius = 7
        if Sound {
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
        }else{
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
        }
        
        PauseMenu.alpha = 0
        HealthImage.image = UIImage(named: "\(health)Health")
        HealthImage.alpha = 0
        HealthImage.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        update()
        
        let HornSoundPath = Bundle.main.path(forResource: "Horn", ofType: "wav")
        let CorrectSoundPath = Bundle.main.path(forResource: "Correct", ofType: "wav")
        let WrongSoundPath = Bundle.main.path(forResource: "Wrong", ofType: "wav")
        do{
            try HornSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: HornSoundPath!))
            try WrongAnswer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: WrongSoundPath!))
            try CorrectAnswer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: CorrectSoundPath!))
        }catch{
            print(error)
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        AdBannerHeight.constant = 0
        AdBanner.isHidden = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        AdBannerHeight.constant = 50
        AdBanner.isHidden = false
    }
    
    func readPlist(name: String)->[String]?{
       if let path = Bundle.main.path(forResource: name, ofType: "plist"),
         let CarsList = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: CarsList, options: .mutableContainers, format: nil)) as? [String]
            }else{
                return nil
        }
        
    }
    
    func readPlist2(name: String)->[String:[String]]?{
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let CarsList = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: CarsList, options: .mutableContainers, format: nil)) as? [String:[String]]
        }else{
            return nil
        }
        
    }
    
    @objc func timeLeft(){
        if timeProgress.progress == 1{
            timer.invalidate()
        }else{
            timeProgress.progress += 1/1500
        }
    }
    
    //Buttons
    //Answers variant buttons
    @IBAction func FirstVariantBtn(_ sender: Any) {
        makeGuess(button: FirstVariant)
    }
    
    @IBAction func SecondVariantBtn(_ sender: Any) {
       makeGuess(button: SecondVariant)
    }
    
    @IBAction func ThirdVariantBtn(_ sender: Any) {
       makeGuess(button: ThirdVariant)
    }
    
    @IBAction func FourthVariantBtn(_ sender: Any) {
      makeGuess(button: FourthVariant)
    }
    
    //Enabling/Disabling sound in pause menu
    @IBAction func Sound(_ sender: Any) {
        switch Sound {
        case true:
            Sound = false
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
            break
        case false:
            Sound = true
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
        break
        }
    }
    
    
    //Pause Button and Pause Menu buttons
    @IBAction func pauseAlpha(_ sender: Any) {
        Pause.MakeBrighter()
    }
    @IBAction func pauseBtn(_ sender: Any) {
        Pause.alpha = 1
        Health_PauseMenu.image = UIImage(named: "\(health)Health")
        carsGuessed_PauseMenu.text = String(cars)
        Score_PauseMenu.text = String(score)
        self.PauseMenu.isHidden = false
        UIView.animate(withDuration: 0.3){
            self.PauseMenu.alpha = 1
        }
        timer.invalidate()
        scoreTimer.invalidate()
    }
    
    
    @IBAction func MainMenubtn(_ sender: Any) {
        let alert = UIAlertController(title: "Are You Sure?", message: "Do you want to exit?\nYour progress won't be saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit" , style: .default, handler: {
            (alert: UIAlertAction)-> Void in
            self.performSegue(withIdentifier: "MainMenu", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func continueBtn(_ sender: Any) {
        PauseMenu.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeLeft), userInfo: nil, repeats: true)
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreCounter), userInfo: nil, repeats: true)
    }
    
    
    
    //Help Button and Help Menu Buttons
    @IBAction func helpAlpha(_ sender: Any) {
        Help.MakeBrighter()
    }
    
    @IBAction func helpBtn(_ sender: Any) {
        Help.alpha = 1
        if HintButton.isHidden == true{
            
            HintButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.6)
            ExtraTime.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.6)
            SkipButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.6)
            
            HintButton.isHidden = false
            ExtraTime.isHidden = false
            SkipButton.isHidden = false
            
            HealthImage.isHidden = true
            
            closeHelp = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(closeHelpBtns), userInfo: nil, repeats: false)
        }else{
            
            HintButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
            ExtraTime.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
            SkipButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
            
            HintButton.isHidden = true
            ExtraTime.isHidden = true
            SkipButton.isHidden = true
            closeHelp.invalidate()
        }
        
        
    }
    
    @objc func closeHelpBtns(){
        HintButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
        ExtraTime.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
        SkipButton.backgroundColor = UIColor(red: 225/255, green: 237/255, blue: 222/255, alpha: 0.0)
        
        HintButton.isHidden = true
        ExtraTime.isHidden = true
        SkipButton.isHidden = true
        
        
    }
    
    
    @IBAction func HintBtnAlpha(_ sender: Any) {
        HintButton.MakeBrighter()
    }
    
    @IBAction func HintBtn(_ sender: Any) {
        HintButton.MakeBrighter()
        HintButton.isEnabled = false
        RandomHintButtonGenerator()
        for i in 0 ... 3 {
            if i != randomHintNumber - 1 && i != randomNum - 1{
                VariantsButtonsArray[i].setTitle("", for: .normal)
                VariantsButtonsArray[i].isEnabled = false
            }
        }
        
    }
    
    
    @IBAction func ExtraTimeAlpha(_ sender: Any) {
        ExtraTime.MakeBrighter()
    }
    
    @IBAction func ExtraTimeBtn(_ sender: Any) {
        timeProgress.progress = 0
        scoreTimer.invalidate()
        seconds = 15
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreCounter), userInfo: nil, repeats: true)
        ExtraTime.isEnabled = false
    }
    
    
    @IBAction func SkipAlpha(_ sender: Any) {
        SkipButton.MakeBrighter()
    }
    @IBAction func SkipBtn(_ sender: Any) {
        update()
        SkipButton.isEnabled = false
    }
    
    
    
    
    func makeGuess(button : UIButton){
        
        FirstVariant.isEnabled = false
        SecondVariant.isEnabled = false
        ThirdVariant.isEnabled = false
        FourthVariant.isEnabled = false
        Help.isEnabled = false
        
        if check(name: button.title(for: .normal)!) == true{
            cars += 1
            score += seconds
            scores.text = String(score)
            button.layer.backgroundColor = UIColor.green.cgColor
            timer.invalidate()
            scoreTimer.invalidate()
            carsGuessed.text = String(cars)
            if Sound{
            CorrectAnswer.play()
            }
            
            UpdTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
            
        }else{
            //Показывание кол-ва хп
            health -= 1
            showHealthFunc()
            timer.invalidate()
            scoreTimer.invalidate()
            button.layer.backgroundColor = UIColor.red.cgColor
            if Sound{
            WrongAnswer.play()
            }
            if health != 0 {
                 UpdTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
            }else{
                 UpdTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameOverTimer), userInfo: nil, repeats: false)
            }
        }
        
       
    }
    
    
    
    //Функция которая показывает кол-во хп в верху изображения и прячет кнопки подсказок если они включены
    func showHealthFunc(){
        HealthImage.image = UIImage(named: "\(health)Health")
        HealthImage.isHidden = false
        UIView.animate(withDuration: 0.3){
            self.HealthImage.alpha = 1
            
        }
        showHealth.invalidate()
        HintButton.isHidden = true
        ExtraTime.isHidden = true
        SkipButton.isHidden = true
        showHealth = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(hideHP), userInfo: nil, repeats: false)
    }
    
    
    
    @objc func gameOverTimer(){
        GameOver()
    }
    
    @objc func updateTimer(){
        update()
    }
   
    @objc func hideHP(){
        UIView.animate(withDuration: 0.3){
            self.HealthImage.alpha = 0
        }
        HealthImage.isHidden = true
    }
    
   
    
    
    //Функция принимает текст с кнопки сверяет с названием картинки и выдает значение true или false, при этом удаляя название картинки из массива названий
    func check(name: String)->Bool{
        if name == CurrentCar{
            return true
        }else{
            return false
        }
    }
    
    
    func GameOver(){
        ScoresAPI().SaveNewScore(score: score, cars: cars)
        performSegue(withIdentifier: "GameOver", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GameOver":
            let vc = segue.destination as! GameOverViewController
            vc.Sound = Sound
            vc.cars = cars
            vc.score = score
            
        case "MainMenu":
            let vc = segue.destination as! ViewController
            vc.Sound = Sound
            
        default:
            print("Error with segue from GameProcessViewController")
        }
      
    }
    
    
    
    func GetCar(){
     let RandomCarNameNum = Int.random(in: 0 ..< CarNamesArray.count)
     CarName = CarNamesArray[RandomCarNameNum]
        
        if let ModelsArray = UnusedCars[CarName], ModelsArray.count != 0{
            let randomCarCount = Int.random(in: 0 ..< ModelsArray.count)
            if CarName == "Other"{
                CurrentCar = ModelsArray[randomCarCount]
            }else{
              CurrentCar = CarName + " " + ModelsArray[randomCarCount]
            }
            
            UnusedCars[CarName]!.remove(at: randomCarCount)
            if UnusedCars[CarName]!.count == 0{
                UnusedCars.removeValue(forKey: CarName)
                CarNamesArray.remove(at: RandomCarNameNum)
            }
            
        }else{
            
            GetCar()
        }
    }
    
    
    func update(){
        
        
        
        GetCar()
        
        
       
        CarImage.image = UIImage(named: CurrentCar)
       
        FirstVariant.isEnabled = true
        SecondVariant.isEnabled = true
        ThirdVariant.isEnabled = true
        FourthVariant.isEnabled = true
        Help.isEnabled = true
        
        
        randomNum = Int.random(in: 1 ... 4)
        
        switch randomNum{
        case 1: FirstVariant.setTitle(CurrentCar, for: .normal)
                ExtraButtonTitle()
                SecondVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                ThirdVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                FourthVariant.setTitle(titleButton, for: .normal)
            
        case 2: SecondVariant.setTitle(CurrentCar, for: .normal)
                ExtraButtonTitle()
                FirstVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                ThirdVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                FourthVariant.setTitle(titleButton, for: .normal)
            
        case 3: ThirdVariant.setTitle(CurrentCar, for: .normal)
                ExtraButtonTitle()
                SecondVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                FirstVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                FourthVariant.setTitle(titleButton, for: .normal)
            
        case 4: FourthVariant.setTitle(CurrentCar, for: .normal)
                ExtraButtonTitle()
                SecondVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                ThirdVariant.setTitle(titleButton, for: .normal)
                ExtraButtonTitle()
                FirstVariant.setTitle(titleButton, for: .normal)
        default: print("Error with updating current screen")
        }
        
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeLeft), userInfo: nil, repeats: true)
        timeProgress.progress = 0
        scoreTimer.invalidate()
        seconds = 15
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreCounter), userInfo: nil, repeats: true)
        
        FirstVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        SecondVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        ThirdVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        FourthVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        
        

        VariantsForButtons = readPlist2(name: "CarsVariants")!
    }
    
    @objc func scoreCounter(){
        if seconds < 1{
            scoreTimer.invalidate()
            seconds = 0
            health -= 1
            if health != 0{
                showHealthFunc()
                update()
            }else{
                GameOver()
            }
            
        } else{
            
            seconds -= 1
        }
        
        if seconds <= 3 && seconds >= 1 && Sound == true{
            HornSound.play()
        }
        
    }
    
    
    /* Функиция которая из Dictionary авто добавляет в переменную title
    какое-либо название авто если оно совпадает с названием авто на картинке то функция вызывает
     себя же опять чтобы не было двух одинаковых кнопок, так же удаляет использованное название
     
     */
    func ExtraButtonTitle(){
        var Car = CarName //строковая переменная с названием ключа в словаре VariantsForButtons
        
        if VariantsForButtons[Car]!.count <= 0{   // проверка на количество элементов массива с автомобилями данной марки
        Car = "Other"                             // если элементы закончились, то переменной Car присваиваем значение "Other",
        }                                         // чтобы следующие значение брались из массива дополнительных авто
        
        let randomExtraCar = Int.random(in: 0 ..< VariantsForButtons[Car]!.count)
        if Car == "Other"{
            titleButton = VariantsForButtons[Car]![randomExtraCar]   // чтобы не отображать слово 'Other' в названии авто на кнопке
        }else{
        titleButton = CarName + " " + VariantsForButtons[Car]![randomExtraCar]
        }
        VariantsForButtons[Car]!.remove(at: randomExtraCar) // удаляем этот элемент из массива, чтобы несколько раз им не заполнить кнопки
        if titleButton == CurrentCar{   // если подобранный вариант совпадает с title кнопки то функция срабатывает заново
            ExtraButtonTitle()
        }
    }
    
    /** Function that generates random number for lefting two buttons enabled
     (Button with right answer and Button that is generated by this function).
     If generated numer equals to number of button with right answer function
     is called agian to get unique number
     
     - returns: Nothing
     */
    func RandomHintButtonGenerator(){
        randomHintNumber = Int.random(in: 1...4)
        if randomHintNumber == randomNum{
            RandomHintButtonGenerator()
        }
    }
    
}

extension  UIButton {
    func customCorner(){
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 193/255, green: 247/255, blue: 14/255, alpha: 0.8).cgColor
        self.title
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    func MakeBrighter(){
        self.alpha = 0.7
    }
    
}
