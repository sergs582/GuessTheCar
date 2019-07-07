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
    @IBOutlet weak var SoundBtn: UIButton!
    @IBOutlet weak var ProBtn: UIButton!
    
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
    
    var BackSound : AVAudioPlayer = AVAudioPlayer()
    
    var product : SKProduct?
    var productID = "com.juniorsoftcorp.guessthecar.proversion"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let soundPath = Bundle.main.path(forResource: "BackgroundSound", ofType: "mp3")
        
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
        Button2.layer.backgroundColor = UIColor(red: 219/255, green: 208/255, blue: 0/255, alpha: 1).cgColor
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
    
    
    @IBAction func Play(_ sender: Any) {
        BackSound.stop()
        BackSound.currentTime = 0
        timer.invalidate()
        soundTimer.invalidate()
       
        performSegue(withIdentifier: "Game", sender: self)
    }

    @IBAction func ScoresBtn(_ sender: Any) {
    performSegue(withIdentifier: "ScoresView", sender: self)
    }
    
    @IBAction func HelpBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Help", message: """
                                            The rules are simple!
                                            Guess what car is on the
                                            image before time is over!
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
              Button2.layer.backgroundColor = UIColor(red: 219/255, green: 208/255, blue: 0/255, alpha: 1).cgColor
        default:
            break
        }
        i+=1
        
    }
    


}

