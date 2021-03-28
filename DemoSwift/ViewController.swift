import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  var dataStack: DATAStack
  var items = [User]()
  
  var fetchedResultsController: NSFetchedResultsController<User>!
  
  enum TableSection {
    case main
  }
  var dataSource: UITableViewDiffableDataSource<TableSection, User>!
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    configureSnapshot()
  }
  
  func configureSnapshot() {
      
      var snapshot = NSDiffableDataSourceSnapshot<TableSection, User>()
      
      do {
          try fetchedResultsController.performFetch()
          
          snapshot.appendSections([.main])
          
          self.items = fetchedResultsController.fetchedObjects ?? []
          
          snapshot.appendItems(self.items)
          
          dataSource.apply(snapshot, animatingDifferences: true)
          
      } catch let error {
          print(error.localizedDescription)
      }
  }
  
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//
//
//    let item = self.items[indexPath.row] as! User
//    if let name = item.value(forKey: "name") as? String, let createdDate = item.value(forKey: "createdDate") as? NSDate {
//      cell!.textLabel?.text = name + " - " + createdDate.description
//    }
//
//    return cell!
//  }
//
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return items.count
//  }
  
  init(dataStack: DATAStack) {
    self.dataStack = dataStack
    
    super.init(style: .plain)
    
    let request: NSFetchRequest = NSFetchRequest<User>(entityName: "User")
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureDataSource() {
    dataSource = .init(tableView: tableView, cellProvider: { (tableView, indexPath, company) -> UITableViewCell? in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
      
      let item = self.items[indexPath.row] as! User
      if let name = item.value(forKey: "name") as? String, let createdDate = item.value(forKey: "createdDate") as? NSDate {
        cell.textLabel?.text = name + " - " + createdDate.description
      }
      
      return cell
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    configureDataSource()
    configureSnapshot()
    //self.tableView.dataSource = self
    
    let backgroundButton = UIBarButtonItem(title: "Background", style: .done, target: self, action: #selector(self.createBackground))
    self.navigationItem.rightBarButtonItem = backgroundButton
    
    let mainButton = UIBarButtonItem(title: "Main", style: .done, target: self, action: #selector(ViewController.createMain))
    self.navigationItem.leftBarButtonItem = mainButton
  }
  
  @objc func createBackground() {
    self.dataStack.performInNewBackgroundContext { backgroundContext in
      let entity = NSEntityDescription.entity(forEntityName: "User", in: backgroundContext)!
      let object = NSManagedObject(entity: entity, insertInto: backgroundContext)
      object.setValue("Background", forKey: "name")
      object.setValue(NSDate(), forKey: "createdDate")
      try! backgroundContext.save()
    }
  }
  
  @objc func createMain() {
    let entity = NSEntityDescription.entity(forEntityName: "User", in: self.dataStack.mainContext)!
    let object = NSManagedObject(entity: entity, insertInto: self.dataStack.mainContext)
    object.setValue("Main", forKey: "name")
    object.setValue(Date(), forKey: "createdDate")
    try! self.dataStack.mainContext.save()
  }
}
