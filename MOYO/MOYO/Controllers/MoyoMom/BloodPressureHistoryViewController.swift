//
//  BloodPressureHistoryViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 6/14/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import CoreData

class BloodPressureHistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    private let persistentContainer = NSPersistentContainer(name: "MoyoMom")
         
     override func viewDidLoad() {
         super.viewDidLoad()
         
         //UNCOMMENT FOR CHART
         
     //    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "graph"), style: .plain, target: self, action: #selector(chartAction))
         
         
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         
         persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
              if let error = error {
                  print("Unable to Load Persistent Store")
                  print("\(error), \(error.localizedDescription)")

              } else {
                  self.setupView()
                 do {
                                try self.fetchedResultsController.performFetch()
                            } catch {
                                let fetchError = error as NSError
                                print("Unable to Perform Fetch Request")
                                print("\(fetchError), \(fetchError.localizedDescription)")
                            }
              }
             
          }
         
         self.navigationItem.title = "Vitals History"
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
     }
     
     private func setupView() {

     }
     
     //UNCOMMENT FOR CHART
 //    @objc func chartAction() {
 //       self.performSegue(withIdentifier: "showVitalsChart", sender: self)
 //    }
     
     fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ReportedVitals> = {
         // Create Fetch Request
         let fetchRequest: NSFetchRequest<ReportedVitals> = ReportedVitals.fetchRequest()

         // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "reportedDate", ascending: false)]

         // Create Fetched Results Controller
         let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

         // Configure Fetched Results Controller
         fetchedResultsController.delegate = self

         return fetchedResultsController
     }()
   
    
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(true)
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     }
     
     // MARK: - Table view data source
     
     override func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
         return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
         guard let reported = fetchedResultsController.fetchedObjects else { return 0 }
         return reported.count
     }
     
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "vitalsHistoryCell", for: indexPath) as! VitalsHistoryTableViewCell
         // Configure the cell...
         
         let quote = fetchedResultsController.object(at: indexPath)
         
         let formatter = DateFormatter()
         formatter.dateFormat = "MMM d, h:mm a"
         cell.notificationTitleLabel.text = "\(quote.arm!.prefix(1).uppercased()) Arm Vitals Reported"
         cell.notificationContentLabel.text = quote.vitals
         cell.notificationDateLabel.text = formatter.string(from: quote.reportedDate!)
         //cell.frame.size.height = tableView.frame.size.height / CGFloat(items.count)
         
         return cell
     }
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return (tableView.frame.size.height - topOffset()) / CGFloat(5)
     }
     
     override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return (tableView.frame.size.height - topOffset()) / CGFloat(5)
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         switch indexPath.row {
         default:
             break
         }
     }

 

}
