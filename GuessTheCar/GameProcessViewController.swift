//
//  GameProcessViewController.swift
//  GuessTheCar
//
//  Created by сергей on 02/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import AVFoundation

class GameProcessViewController: UIViewController {

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
    
    var score : Int = 0
    var seconds : Int = 0
    var cars : Int = 0
    var health : Int = 3
    
    var Sound : Bool = true
    
    
    
    var UnusedCarNames : [String] = ["Ferrari 488 Pista", "Lamborghini Gallardo", "Dodge Challenger Hellcat", "Audi A5", "BMW M5 F90", "Chevrolete Corvete", "Ford Focus RS", "Mercedes-Benz C-Class", "Volvo V40", "Audi 80", "Audi TT", "BMW 3-series", "Chevrolete Tahoe", "Ferrari 488 GTB", "Ford Fiesta", "Ford GT", "Infinity FX37", "Infinity QX56", "Kia Sportage", "Lamborghini Aventador", "Lamborghini Urus", "McLaren 720s", "Mercedes-AMG G63", "Mercedes-Benz CLS-Class"]
    var VariantsForButtons_Easy : [String] = ["Ford Focus", "BMW M5 E60", "Lamborghini Urus","Mercedes-AMG S63", "Nissan GT-R", "Porsche Macan" ,"Audi A5", "BMW M5 F90", "Chevrolette Corvete", "Ford Focus", "Mercedes-Benz C-Class", "Volvo V40", "Audi 80", "Audi TT", "BMW 3-series", "Chevrolete Tahoe", "Ferrari 488 GTB", "Ford Fiesta", "Ford GT", "Infinity FX37", "Infinity QX56", "Kia Sportage", "Lamborghini Aventador", "McLaren 720s", "Mercedes-AMG G63", "Mercedes-Benz CLS-Class"]
    
    var CurrentCar : String = ""
    var titleButton : String = ""
    
    var HornSound : AVAudioPlayer = AVAudioPlayer()
    var WrongAnswer : AVAudioPlayer = AVAudioPlayer()
    var CorrectAnswer : AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var PauseMenu: UIView!
    @IBOutlet weak var ButtonsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        HealthImage.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
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
    
    @objc func timeLeft(){
        if timeProgress.progress == 1{
            timer.invalidate()
        }else{
        timeProgress.progress += 1/1500
            
        }
    }
    
    //Варианты ответов
    @IBAction func FirstVariant(_ sender: Any) {
        makeGuess(button: FirstVariant)
       
      
    }
    
    @IBAction func SecondVariant(_ sender: Any) {
       makeGuess(button: SecondVariant)
        
    }
    
    @IBAction func ThirdVariant(_ sender: Any) {
       makeGuess(button: ThirdVariant)
    }
    
    @IBAction func FourthVariant(_ sender: Any) {
      makeGuess(button: FourthVariant)
        
    }
    
    
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
    
    
    
    func makeGuess(button : UIButton){
        
        FirstVariant.isEnabled = false
        SecondVariant.isEnabled = false
        ThirdVariant.isEnabled = false
        FourthVariant.isEnabled = false
        if check(name: button.title(for: .normal)!) == true{
            cars += 1
            score += seconds
            scores.text = String(score)
            button.layer.backgroundColor = UIColor.green.cgColor
            timer.invalidate()
            scoreTimer.invalidate()
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
    
    //просто делает кнопку светлее 208 255 108
    @IBAction func pauseAlpha(_ sender: Any) {
        Pause.alpha = 0.6
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
        performSegue(withIdentifier: "MainMenu", sender: self)
        
    }
    
    
    
    
    @IBAction func helpAlpha(_ sender: Any) {
        Help.alpha = 0.6
    }
    @IBAction func helpBtn(_ sender: Any) {
        Help.alpha = 1
        if HintButton.isHidden == true{
            
            HintButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
            ExtraTime.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
            SkipButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

            HintButton.isHidden = false
            ExtraTime.isHidden = false
            SkipButton.isHidden = false
            
            HealthImage.isHidden = true
            
        }else{
            
            HintButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
            ExtraTime.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
            SkipButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)

            HintButton.isHidden = true
            ExtraTime.isHidden = true
            SkipButton.isHidden = true
        }
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
            print("error")
        }
      
    }
    
    
    
    
    @IBAction func continueBtn(_ sender: Any) {
        PauseMenu.isHidden = true
         timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeLeft), userInfo: nil, repeats: true)
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreCounter), userInfo: nil, repeats: true)
    }
    
    func update(){
        
        let randomNum = Int.random(in: 1 ... 4)
        let randomCarCount = Int.random(in: 0 ..< UnusedCarNames.count)
        CurrentCar = UnusedCarNames[randomCarCount]
        UnusedCarNames.remove(at: randomCarCount)
        CarImage.image = UIImage(named: CurrentCar)
       
        FirstVariant.isEnabled = true
        SecondVariant.isEnabled = true
        ThirdVariant.isEnabled = true
        FourthVariant.isEnabled = true
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
        default: print("error")
        }
        
        timeProgress.progress = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeLeft), userInfo: nil, repeats: true)
        scoreTimer.invalidate()
        seconds = 15
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreCounter), userInfo: nil, repeats: true)
        FirstVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        SecondVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        ThirdVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        FourthVariant.backgroundColor = UIColor(red: 208/255, green: 255/255, blue: 108/255, alpha: 1.0)
        carsGuessed.text = String(cars)

        VariantsForButtons_Easy = ["Ford Focus", "BMW M5 E60", "Lamborghini Urus","Mercedes-AMG S63", "Nissan GT-R", "Porsche Macan" ,"Audi A5", "BMW M5 F90", "Chevrolette Corvete", "Ford Focus", "Mercedes-Benz C-Class", "Volvo V40", "Audi 80", "Audi TT", "BMW 3-series", "Chevrolete Tahoe", "Ferrari 488 GTB", "Ford Fiesta", "Ford GT", "Infinity FX37", "Infinity QX56", "Kia Sportage", "Lamborghini Aventador", "McLaren 720s", "Mercedes-AMG G63", "Mercedes-Benz CLS-Class"]
        
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
    
    
    /* Функиция которая из массива неиспользованных имен авто добавляет в переменную title
    какое-либо название авто если оно совпадает с названием авто на картинке то функция вызывает
     себя же опять чтобы не было двух одинаковых кнопок, так же удаляет использованное название */
    func ExtraButtonTitle(){
        
        let randomExtraCar = Int.random(in: 0 ..< VariantsForButtons_Easy.count)
        titleButton = VariantsForButtons_Easy[randomExtraCar]
        VariantsForButtons_Easy.remove(at: randomExtraCar)
        if titleButton == CurrentCar{
          ExtraButtonTitle()
        }
    }
    
    
    
}





extension  UIButton {
    func customCorner(){
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 193/255, green: 247/255, blue: 14/255, alpha: 0.8).cgColor
    }
    
}
