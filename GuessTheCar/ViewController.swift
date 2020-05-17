//
//  ViewController.swift
//  GuessTheCar
//
//  Created by сергей on 01/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit

class ViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button1: UIButton!
    
    
    @IBOutlet weak var AllCarsMode: UIButton!
    @IBOutlet weak var ClassicCarsMode: UIButton!
    @IBOutlet weak var SportCarsMode: UIButton!
    @IBOutlet weak var Mode4x4: UIButton!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var SoundBtn: UIButton!
    @IBOutlet weak var ProBtn: UIButton!
    
    @IBOutlet weak var TraficLight: UIImageView!
    @IBOutlet weak var MainButtonsStack: UIStackView!
    @IBOutlet weak var ModesView: UIScrollView!
    
    @IBOutlet weak var ScrollViewConstraint: NSLayoutConstraint!
    
    
    
    
    var ProVersionAlert: UIAlertController = UIAlertController()
    
    var timer = Timer()
    var soundTimer = Timer()
    
    let FailAlertMessage = "Please, Check your internet connection!"
    var message: String = ""
    
    var i = 1
    
    var Sound : Bool = true
    var CanCustomizeAlert: Bool = false
    var isProPurchased: Bool = false
    var IsCustomized: Bool = false
    
    var BackSound : AVAudioPlayer!
    
    var product : SKProduct?
    var productID = "com.juniorsoftcorp.guessthecar.proversion"
    
    var ModePathValue = String()
    
    let IPHONE_5_HEIGHT : CGFloat = 568
    let IPHONE_8_HEIGHT : CGFloat = 667
    let IPHONE_8PLUS_HEIGHT: CGFloat = 736
    let IPHONE_XS_HEIGHT: CGFloat = 812
    let IPHONE_Xr_HEIGHT : CGFloat = 896
    let IPHONE_XSMax_HEIGHT: CGFloat = 896
    
    let ALL_CARS_MODE = 1
    let CLASSIC_CARS_MODE = 2
    let SPORT_CARS_MODE = 3
    let MODE_4X4 = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ScreenSize : CGRect = UIScreen.main.bounds
        switch ScreenSize.height{
        case IPHONE_5_HEIGHT:
            ScrollViewConstraint.constant = 212
        case IPHONE_8_HEIGHT:
            ScrollViewConstraint.constant = 245
        case IPHONE_8PLUS_HEIGHT:
            ScrollViewConstraint.constant = 270
        case IPHONE_XS_HEIGHT:
            ScrollViewConstraint.constant = 280
        case IPHONE_Xr_HEIGHT:
            ScrollViewConstraint.constant = 310
        case IPHONE_XSMax_HEIGHT:
            ScrollViewConstraint.constant = 310
        default:
            break
        }
        
        BackBtn.isEnabled = false
        if !(UserDefaults.standard.value(forKey: "ReviewLeft") as! Bool){
            SportCarsMode.alpha = 0.5
            ClassicCarsMode.alpha = 0.5
            Mode4x4.alpha = 0.5
        }
        
        
        ModesView.alpha = 0
        
        
        
        let soundPath = Bundle.main.path(forResource: "BackgroundSound", ofType: "mp3")
        print(soundPath!)
        do{
          try BackSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
        }catch{
            print(error)
        }
        
        isProPurchased = Preferences().getProVersionState()
        
        Button1.layer.cornerRadius = Button1.frame.height/2
        Button2.layer.cornerRadius = Button2.frame.height/2
        Button3.layer.cornerRadius = Button3.frame.height/2
        
        Button1.titleLabel?.font = UIFont(name: "CustomChalkduster", size: 15)
        Button2.titleLabel?.font = UIFont(name: "CustomChalkduster", size: 15)
        Button3.titleLabel?.font = UIFont(name: "CustomChalkduster", size: 15)
       
        Button1.isExclusiveTouch = true
        Button2.isExclusiveTouch = true
        Button3.isExclusiveTouch = true
        
        AllCarsMode.isExclusiveTouch = true
        SportCarsMode.isExclusiveTouch = true
        ClassicCarsMode.isExclusiveTouch = true
        Mode4x4.isExclusiveTouch = true
        
        ProVersionAlert = UIAlertController(title: "Pro Version", message: message, preferredStyle: .alert)
        ProVersionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        Sound = Preferences().getSoundState()
        if Sound {
            playSound()
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
            
        }else{
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
        }
        
        Button1.layer.backgroundColor = UIColor.red.cgColor
        Button2.layer.backgroundColor = UIColor(red: 189/255, green: 179/255, blue: 2/255, alpha: 1).cgColor
        Button3.layer.backgroundColor = UIColor(red: 40/255, green: 132/255, blue: 11/255, alpha: 1).cgColor
        
        timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(lights), userInfo: nil, repeats: true)
        
        
      
        if isProPurchased{
            ProPurchased()
        }
        SKPaymentQueue.default().add(self)
        getPurchsedInfo()
        
        
    }
    
    @objc func repeatSound(){
        BackSound.stop()
        BackSound.currentTime = 0
        BackSound.play()
        BackSound.volume = 0.8
    }
    
    func playSound(){
        soundTimer.invalidate()
        BackSound.stop()
        BackSound.currentTime = 0
        BackSound.play()
        BackSound.volume = 0.8
        soundTimer = Timer.scheduledTimer(timeInterval: 28, target: self, selector: #selector(repeatSound), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func ProPurchase(_ sender: Any) {
        if CanCustomizeAlert && !IsCustomized {
            ProVersionAlert.message = product!.localizedDescription
            ProVersionAlert.addAction(UIAlertAction(title: "Get", style: .default, handler: {(alert: UIAlertAction)->Void in self.buyPro()}))
            ProVersionAlert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { action in SKPaymentQueue.default().restoreCompletedTransactions()}))
          IsCustomized = true
        }else{
            ProVersionAlert.message = message
        }
        
       self.present(ProVersionAlert, animated: true, completion: nil)
    
    }
    
 
    
    func buyPro(){
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if (products.count == 0){
        message = FailAlertMessage
       
        }else{
            product = products[0]
            message = product!.localizedDescription
            CanCustomizeAlert = true
        }
        
        let invalid = response.invalidProductIdentifiers
        for product in invalid{
            print("\(product)")
        }
    }
    
    func getPurchsedInfo(){
        if SKPaymentQueue.canMakePayments(){
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            ProVersionAlert.message = "Enable IAP on your device"
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                ProPurchased()
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                CanCustomizeAlert = true
            case SKPaymentTransactionState.restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                ProPurchased()
            default:
               break
            }
        }
       
    }
    
    func ProPurchased(){
        ProBtn.isEnabled = false
        ProBtn.setImage(UIImage(named: "pro1"), for: .normal)
        isProPurchased = Preferences().setProVersionState(state: true)
    }
    
    @IBAction func Sound(_ sender: Any) {
        switch Sound {
        case true:
            Sound = Preferences().setSoundState(state: false)
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
            BackSound.stop()
            soundTimer.invalidate()
            break
        case false:
            Sound = Preferences().setSoundState(state: true)
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
            playSound()
            break
        }
        
    }
    
    
    @IBAction func Back(_ sender: Any) {
        UIView.animate(withDuration: 0.3){
            self.ModesView.alpha = 0
        }
        ModesView.isHidden = true
        TraficLight.isHidden = false
        MainButtonsStack.isHidden = false
        ProBtn.isHidden = false
        SoundBtn.isHidden = false
        BackBtn.isHidden = true
        BackBtn.isEnabled = false
        
    }
    
    //Play button on the trafic light
    @IBAction func Play(_ sender: Any) {
        TraficLight.isHidden = true
        MainButtonsStack.isHidden = true
        ProBtn.isHidden = true
        SoundBtn.isHidden = true
        ModesView.isHidden = false
        UIView.animate(withDuration: 0.3){
            self.ModesView.alpha = 1
        }
        BackBtn.isHidden = false
        BackBtn.isEnabled = true
        

    }
    
   
    
    
    //saving game mode to user defaults in order to have access to it in GameOverVC (for restart button)
    func play(withMode mode: String){
        let save = UserDefaults.standard
       
        
        if mode != "AllCars" && !(save.value(forKey: "ReviewLeft") as! Bool){
            let alert  = UIAlertController(title: "Rate Us!", message: """
                                                                            To unlock all modes absolutely for free
                                                                            just leave us 5 stars on the AppStore!
                                                                       """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Rate", style: .default, handler: { action in
                guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1471612618?action=write-review")
                    else { fatalError("Expected a valid URL") }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: {_ in
                    save.set(true, forKey: "ReviewLeft")
                })
                self.SportCarsMode.alpha = 1
                self.ClassicCarsMode.alpha = 1
                self.Mode4x4.alpha = 1
            }))
            alert.addAction(UIAlertAction(title: "Later", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
         save.setValue(mode, forKey: "mode")
          performSegue(withIdentifier: "Game", sender: self)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        BackSound.stop()
        BackSound.currentTime = 0
        timer.invalidate()
        soundTimer.invalidate()
    }
    
    
    //Function for all "Mode" buttons, gets their tag and transforms it into "mode" String with switch-state
    @IBAction func SelectPlayMode(_ sender: Any) {
        
        guard let btn = sender as? UIButton else{
            return
        }
        switch btn.tag {
        case ALL_CARS_MODE :
            play(withMode: "AllCars")
        case CLASSIC_CARS_MODE :
            play(withMode: "ClassicCars")
        case SPORT_CARS_MODE :
            play(withMode: "SportCars")
        case MODE_4X4 :
            play(withMode: "4x4Cars")
        default:
            break
        }
        
    }
    
   
    @IBAction func ScoresBtn(_ sender: Any) {
    performSegue(withIdentifier: "ScoresView", sender: self)
    }
    
    @IBAction func HelpBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Help", message: """
                                            The rules are simple!
                                            Guess what car is on the
                                            image before time is over!
                                            Don't forget about tips at the top.
                                            If you want to add your favourite
                                            car, send it to our e-mail
                                            juniorsoftcorp@gmail.com or leave
                                            in AppStore review!
                                            """, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default
            , handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    @objc func lights(){
        if i == 4{
            i = 1
        }
        switch i {
        case 1:
          Button1.layer.backgroundColor = UIColor.red.cgColor
              Button3.layer.backgroundColor = UIColor(red: 40/255, green: 132/255, blue: 11/255, alpha: 1).cgColor
        case 2:
             Button1.layer.backgroundColor = UIColor(red: 193/255, green: 13/255, blue: 3/255, alpha: 1).cgColor
            Button2.layer.backgroundColor = UIColor.yellow.cgColor
        case 3:
             Button3.layer.backgroundColor = UIColor.green.cgColor
              Button2.layer.backgroundColor = UIColor(red: 189/255, green: 179/255, blue: 2/255, alpha: 1).cgColor
        default:
            break
        }
        i+=1
        
    }
    


}

