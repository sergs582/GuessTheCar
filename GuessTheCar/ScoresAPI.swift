

import Foundation

class ScoresAPI {
    
    
    struct ScoresStruct : Codable{
        var No1 : [String: Int] = [:]
        var No2 : [String: Int] = [:]
        var No3 : [String: Int] = [:]
        var No4 : [String: Int] = [:]
        var No5 : [String: Int] = [:]
    }
    
    /*Функция возвращает структуру состоящую из полей файла plist для
     дальнейшего преобразования в массив в функции GetScoresList()
     или записи новых данных в plist в функции SaveNewScore()
    */
    func GetScoresStruct() -> ScoresStruct{
        if let ScoresPath = Bundle.main.path(forResource: "Scores", ofType: "plist"),
            let ScoresBD = FileManager.default.contents(atPath: ScoresPath),
            let Scores = try? PropertyListDecoder.init().decode(ScoresStruct.self, from: ScoresBD){
            return Scores
        }else{
            print("error reading scores file")
            let emptyScoresStruct : ScoresStruct = ScoresStruct(No1: [:], No2: [:], No3: [:], No4: [:], No5: [:])
            return emptyScoresStruct
        }
        
        
    }
   
    func GetScoresList() -> [Int]{
        let Scores = GetScoresStruct()
         var ScoresList = [Int]()
        ScoresList.append(Scores.No1["Scores"]!)
        ScoresList.append(Scores.No2["Scores"]!)
        ScoresList.append(Scores.No3["Scores"]!)
        ScoresList.append(Scores.No4["Scores"]!)
        ScoresList.append(Scores.No5["Scores"]!)
        return ScoresList
    }
    
    func GetCarsList() -> [Int]{
        let Cars = GetScoresStruct()
        var CarsList = [Int]()
        CarsList.append(Cars.No1["Cars"]!)
        CarsList.append(Cars.No2["Cars"]!)
        CarsList.append(Cars.No3["Cars"]!)
        CarsList.append(Cars.No4["Cars"]!)
        CarsList.append(Cars.No5["Cars"]!)
        return CarsList
    }
    
    /*
     SaveNewScore() -- Function that gets two values (score and cars)
     It is called when game overs and current score and cars are sent to this func
     Here it gets an array of existing scores/cars from .plist file and adding the current score/cars
     as the 6th element of array, then it sorts, removes last element to get top 5
     and after that it fills struct with proper data and updates the plist file
   */
    func SaveNewScore(score: Int, cars: Int){
        var Scores = GetScoresStruct()
        
        var ScoresArray = GetScoresList()
        var CarsArray = GetCarsList()
        
        ScoresArray.append(score)
        CarsArray.append(cars)
        
        ScoresArray.sort()
        CarsArray.sort()
        
        ScoresArray.reverse()
        CarsArray.reverse()
        
        ScoresArray.removeLast()
        CarsArray.removeLast()
        
        Scores.No1 = ["Scores": ScoresArray[0], "Cars" : CarsArray[0]]
        Scores.No2 = ["Scores": ScoresArray[1], "Cars" : CarsArray[1]]
        Scores.No3 = ["Scores": ScoresArray[2], "Cars" : CarsArray[2]]
        Scores.No4 = ["Scores": ScoresArray[3], "Cars" : CarsArray[3]]
        Scores.No5 = ["Scores": ScoresArray[4], "Cars" : CarsArray[4]]
        
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
    
        let path = Bundle.main.url(forResource: "Scores", withExtension: "plist")
    
    
        do{
            let data =  try encoder.encode(Scores)
            try data.write(to: path!)
        }catch{
            print(error)
        }
    }
}
