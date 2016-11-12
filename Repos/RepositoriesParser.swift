import Foundation

typealias JSONDictionary = [String: AnyObject]

class RepositoriesParser {
    func parseDictionary(data: NSData?) -> JSONDictionary? {
        do {
            if let data = data,
                json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                    return json
            }
        } catch {
            print("Couldn't parse JSON. Error: \(error)")
        }
        return nil
    }
    
    func repositoriesFromSearchResponse(data: NSData?) -> [Repository]? {
        guard let dict = parseDictionary(data) else {
            print("Error: couldn't parse dictionary from data")
            return nil
        }
        
        guard let repoDicts = dict["items"] as? [JSONDictionary] else {
            print("Error: couldn't parse items from JSON: \(dict)")
            return nil
        }
        
        return repoDicts.flatMap { parseRepository($0) }
    }
    
    func parseRepository(dict: JSONDictionary) -> Repository? {
        if let id = dict["id"] as? Int,
            name = dict["name"] as? String,
            description = dict["description"] as? String {
                
                let htmlURL = dict["html_url"] as? String
                let repo = Repository(id: id, name: name, description: description, htmlURL: htmlURL)
                return repo
        } else {
            print("Error: couldn't parse JSON dictionary: \(dict)")
        }
        return nil
    }
}