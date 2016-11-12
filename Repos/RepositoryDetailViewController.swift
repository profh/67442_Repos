import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    
    var viewModel: RepositoryDetailViewModel?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = viewModel?.title()

        if let viewModel = viewModel,
            urlString = viewModel.URLString(),
            url = NSURL(string: urlString) {
                let request = NSURLRequest(URL: url)
                webView?.loadRequest(request)
        }
    }
}