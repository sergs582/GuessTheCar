
import Foundation


class Preferences{
    
    private var IsProVersionPurchased : Bool = false
    private var IsSoundEnabled : Bool = true
    
    init() {
        self.IsSoundEnabled = GetValue(name: "Sound")
        self.IsProVersionPurchased = GetValue(name: "ProVersion")
    }
    
    func getProVersionState()->Bool{
        
        return IsProVersionPurchased
    }
    
    func setProVersionState(state: Bool)->Bool{
        SetValue(Key: "ProVersion", Data: state)
        return state
    }
    
    func getSoundState()->Bool{
        
        return IsSoundEnabled
    }
    
    func setSoundState(state: Bool)->Bool{
         SetValue(Key: "Sound", Data: state)
        return state
    }
    
  private func GetValue(name: String)->Bool{
       return UserDefaults.standard.bool(forKey: name)
    }
    
    
    
   private func SetValue(Key: String, Data: Bool){
    let save = UserDefaults.standard
    save.setValue(Data, forKey: Key)
    save.synchronize()
    }


}
