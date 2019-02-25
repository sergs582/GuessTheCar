//
//  ViewController.swift
//  GuessTheCar
//
//  Created by сергей on 01/02/2019.
//  Copyright © 2019 сергей. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var SoundBtn: UIButton!
    var timer = Timer()
    var soundTimer = Timer()
    var i = 1
    var Sound : Bool = true
    var BackSound : AVAudioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundPath = Bundle.main.path(forResource: "BackgroundSound", ofType: "mp3")
        
        do{
            try BackSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
            
        }catch{
            print(error)
        }
        Button1.layer.cornerRadius = Button1.frame.height/2
        Button2.layer.cornerRadius = Button2.frame.height/2
        Button3.layer.cornerRadius = Button3.frame.height/2
       
        
        
        if Sound {
            playSound()
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
            
        }else{
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
        }
        
        Button1.layer.backgroundColor = UIColor.red.cgColor
        Button2.layer.backgroundColor = UIColor(red: 219/255, green: 208/255, blue: 0/255, alpha: 1).cgColor
        Button3.layer.backgroundColor = UIColor(red: 40/255, green: 132/255, blue: 11/255, alpha: 1).cgColor
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(lights), userInfo: nil, repeats: true)
        
    }
    
    @objc func repeatSound(){
        BackSound.stop()
        BackSound.currentTime = 0
        BackSound.play()
        BackSound.volume = 0.8
    }
    
    func playSound(){
        BackSound.play()
        BackSound.volume = 0.8
        soundTimer = Timer.scheduledTimer(timeInterval: 28, target: self, selector: #selector(repeatSound), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func Info(_ sender: Any) {
    }
    
    @IBAction func Sound(_ sender: Any) {
        switch Sound {
        case true:
            Sound = false
            SoundBtn.setImage(UIImage(named: "SoundOff"), for: .normal)
            BackSound.stop()
            BackSound.currentTime = 0
            soundTimer.invalidate()
            break
        case false:
            Sound = true
            SoundBtn.setImage(UIImage(named: "SoundOn"), for: .normal)
            playSound()
            break
        }
        
    }
    
    
    @IBAction func Play(_ sender: Any) {
        BackSound.stop()
        BackSound.currentTime = 0
        soundTimer.invalidate()
        performSegue(withIdentifier: "Game", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! GameProcessViewController
        vc.Sound = Sound
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
            print("error")
        }
        i+=1
        
    }
    


}

