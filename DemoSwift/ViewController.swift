import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  var dataStack: DATAStack
  var items = [NSFetchRequestResult]()
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
    items = fetchedResultsController.fetchedObjects!
    tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
    
    
    let item = self.items[indexPath.row] as! User
    if let name = item.value(forKey: "name") as? String, let createdDate = item.value(forKey: "createdDate") as? NSDate {
      cell!.textLabel?.text = name + " - " + createdDate.description
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  init(dataStack: DATAStack) {
    self.dataStack = dataStack
    
    super.init(style: .plain)
  
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    self.tableView.dataSource = self
    
    let backgroundButton = UIBarButtonItem(title: "Background", style: .done, target: self, action: #selector(self.createBackground))
    self.navigationItem.rightBarButtonItem = backgroundButton
    
    let mainButton = UIBarButtonItem(title: "Main", style: .done, target: self, action: #selector(ViewController.createMain))
    self.navigationItem.leftBarButtonItem = mainButton
    
    let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    try! fetchedResultsController.performFetch()
    
    items = fetchedResultsController.fetchedObjects!
    
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
