//
//  EventTableViewController.swift
//  RedHatScanner
//
//  Created by Ted Jones - Red Hat on 12/6/17.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var events = [Event]()
    
    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "EventTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Load the sample data.
        loadSampleEvents()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! EventTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        
        let dates = event.getEventDates()
        cell.eventName?.text = event.eventName
        cell.eventLocation?.text = event.eventLocation
        cell.eventDate?.text = dates
    
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadSampleEvents() {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MMM-yyyy"
        
        var startDate: Date? = formatter.date(from: "08-May-2018")
        var endDate: Date? = formatter.date(from: "10-May-2018")
//        guard let event1 = Event(eventName: "Red Hat Summit 2018", eventLocation: "San Francisco, California USA", eventStartDate: startDate!, eventEndDate: endDate!) else {
//            fatalError("Unable to instantiate event1")
//        }
        
        startDate = formatter.date(from: "18-Jun-2018")
        endDate = formatter.date(from: "21-Jun-2018")
        guard let event2 = Event(eventName: "HPE Discover 2018", eventLocation: "Las Vegas, Nevada USA", eventStartDate: startDate!, eventEndDate: endDate!) else {
            fatalError("Unable to instantiate event2")
        }
        
//        startDate = formatter.date(from: "02-Aug-2018")
//        endDate = formatter.date(from: "06-Aug-2018")
//        guard let event3 = Event(eventName: "Nerdvana 2018", eventLocation: "Seattle, Washington USA", eventStartDate: startDate!, eventEndDate: endDate!) else {
//            fatalError("Unable to instantiate event2")
//        }
//
//        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
//            fatalError("Unable to instantiate meal2")
//        }
        
        events += [event2]
    }

}
