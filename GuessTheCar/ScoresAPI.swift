

import Foundation

class ScoresAPI {
    
    
    struct ScoresStruct : Codable{
        var Score1 : String
        var Score2 : String
        var Score3 : String
        var Score4 : String
        var Score5 : String
    }
    
    /*Функция возвращает структуру состоящую из полей файла plist для дальнейшего преобразования в массив в функции GetScoresList()
     или записи новых данных в plist в функции SaveNewScore()
    */
    func GetScoresStruct() -> ScoresStruct{
        if let ScoresPath = Bundle.main.path(forResource: "Scores", ofType: "plist"),
            let ScoresBD = FileManager.default.contents(atPath: ScoresPath),
            let Scores = try? PropertyListDecoder.init().decode(ScoresStruct.self, from: ScoresBD){
            return Scores
        }else{
            print("error reading scores file")
            let emptyScoresStruct : ScoresStruct = ScoresStruct(Score1: "", Score2: "", Score3: "", Score4: "", Score5: "")
            return emptyScoresStruct
        }
        
        
    }
   
    func GetScoresList() -> [String]{
        let Scores = GetScoresStruct()
         var ScoresList = [String]()
            ScoresList.append(Scores.Score1)
            ScoresList.append(Scores.Score2)
            ScoresList.append(Scores.Score3)
            ScoresList.append(Scores.Score4)
            ScoresList.append(Scores.Score5)
        return ScoresList
    }
    
    
    func SaveNewScore(score: String, k: Int){
        var Scores = GetScoresStruct()
      //  Scores.Score5 = score
        
        switch k {
        case 1:
            Scores.Score1 = score
        case 2:
            Scores.Score2 = score
        case 3:
            Scores.Score3 = score
        case 4:
            Scores.Score4 = score
        case 5:
            Scores.Score5 = score
        default:
            print("shit")
        }
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
