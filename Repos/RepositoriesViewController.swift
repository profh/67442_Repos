import UIKit

// MARK: UISearch extension
extension RepositoriesViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// MARK: Repo View Controller
class RepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: Properties & Outlets
  let viewModel = RepositoriesViewModel()
  let searchController = UISearchController(searchResultsController: nil)

  @IBOutlet var tableView: UITableView!
  
  
  // MARK: Std View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // register the nib
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
    // set up the search bar (method below)
    setupSearchBar()
    // get the data for the table
    viewModel.refresh { [unowned self] in
      dispatch_async(dispatch_get_main_queue()) {
          self.tableView.reloadData()
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(selectedRow, animated: true)
    }
  }
  
  
  // MARK: Table View
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
    cell.name?.text = viewModel.titleForRowAtIndexPath(indexPath)
    cell.summary?.text = viewModel.summaryForRowAtIndexPath(indexPath)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("toDetailVC", sender: indexPath)
  }
  
  // MARK: Segues  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let detailVC = segue.destinationViewController as? RepositoryDetailViewController,
      indexPath = sender as? NSIndexPath {
      detailVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath)
    }
  }
  
  
  // MARK: Search Methods
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.barTintColor = UIColor(red:0.98, green:0.48, blue:0.24, alpha:1.0)
  }
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    viewModel.updateFiltering(searchText)
    tableView.reloadData()
  }

}


