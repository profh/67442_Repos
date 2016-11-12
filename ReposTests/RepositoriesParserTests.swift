import XCTest
@testable import Repos

class RepositoriesParserTests: XCTestCase {
    let parser = RepositoriesParser()
    
    func test_parseDictionary() {
        let data = loadJSONTestData("search-repositories-response")
        let results = parser.parseDictionary(data)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(87367, results!["total_count"] as? Int)
    }
    
    func test_parseDictionary_with_invalid_JSON() {
        let data = loadJSONTestData("invalid-response")
        let results = parser.parseDictionary(data)
        
        XCTAssertNil(results)
    }
    
    func test_repositoriesFromSearchResponse() {
        let data = loadJSONTestData("search-repositories-response")
        let results = parser.repositoriesFromSearchResponse(data)
        XCTAssertEqual(30, results!.count)
        
        let first = results!.first!
        XCTAssertEqual(22458259, first.id)
        XCTAssertEqual("Alamofire", first.name)
        XCTAssertEqual("Elegant HTTP Networking in Swift", first.description)
        XCTAssertEqual("https://github.com/Alamofire/Alamofire", first.htmlURL)
    }
    
    func test_repositoriesFromSearchResponse_with_nil_data() {
        let data: NSData? = nil
        let results = parser.repositoriesFromSearchResponse(data)
        XCTAssertNil(results)
    }
    
    func loadJSONTestData(filename: String) -> NSData? {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: "json")
        return NSData(contentsOfFile: path!)
    }
}