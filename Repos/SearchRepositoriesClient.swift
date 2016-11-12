import Foundation

class SearchRepositoriesClient {
    func fetchRepositories(completion: (NSData?) -> Void) {
        let urlString = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"

        guard let url = NSURL(string: urlString) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let error = error {
                print("Error fetching repositories: \(error)")
                completion(data)
                return
            }
            
            completion(data)
        }
        
        task.resume()
    }
}