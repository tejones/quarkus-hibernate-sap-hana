//
//  AttendeeListViewController.swift
//  RedHatScanner
//
//  Created by Ted Jones - Red Hat on 12/6/17.
//

import UIKit

class AttendeeListViewController: UIViewController {
    
    let url = "http://red-hat-raffle.ngrok.io/"
    
    var attendeesArray: [ Attendee ] = [ Attendee ]()
    
    @IBOutlet weak var attendeeTableView: UITableView!
    
    @IBOutlet weak var eventButton: UIBarButtonItem!
    
    var scannedCode:String? = ""
    
    // Table view cells are reused and should be dequeued using     a cell identifier.
    let cellIdentifier = "AttendeeListViewCell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Attendees"
        
        // Load the attendee data.
        loadData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func eventsButtonPushed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private Methods

    func loadData() {
        
        //Clear out attendeesArray
        self.attendeesArray.removeAll()
        
        //Create Activity Indicator
        let attendeesActivityMonitor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        attendeesActivityMonitor.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        attendeesActivityMonitor.hidesWhenStopped = false
        
        // Start Activity Indicator
        attendeesActivityMonitor.startAnimating()
        
        view.addSubview( attendeesActivityMonitor )
        
        let errorMessage = "Attendee request failed"
        let errorMessageTitle = "Error"
        let noAttendeesFound = "There are no scanned attendees."
        let noAttendeesFoundMessageTitle = "No Attendees Found"
        
        // Define base URL
        let baseUrl = url + "raffle/attendees/"
        // Create URL Object
        let myUrl = URL(string: baseUrl);
        
        // Create URL Request
        var request = URLRequest(url:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                self.removeActivityIndicator( activityIndicator: attendeesActivityMonitor )
                self.displayDialog( title: errorMessageTitle, message: errorMessage )
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            if (responseString == nil) {
                self.removeActivityIndicator( activityIndicator: attendeesActivityMonitor )
                print("attendee request failed")
                self.displayDialog(title: errorMessageTitle, message: errorMessage)
            } else {
                if (responseString?.contains("status = 404"))! {
                    self.displayDialog(title: noAttendeesFoundMessageTitle, message: noAttendeesFound)
                    self.removeActivityIndicator( activityIndicator: attendeesActivityMonitor )
                }
            }
            
            do {
                guard let attendeesResponse =  try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                else { return }
                
                //looping through all the json objects in the array 
                for i in 0 ..< attendeesResponse.count{
                    let attendee = Attendee(attendeeFirstName: attendeesResponse[i]["firstName"] as! String, attendeeLastName: attendeesResponse[i]["lastName"] as! String, uid: attendeesResponse[i]["id"] as! String)
                    self.attendeesArray.append( attendee! )
                }
                
                DispatchQueue.main.async{
                    self.attendeeTableView.reloadData()
                    self.removeActivityIndicator( activityIndicator: attendeesActivityMonitor )
                }
                
                
            } catch {
                self.displayDialog(title: errorMessageTitle, message: errorMessage)
                self.removeActivityIndicator( activityIndicator: attendeesActivityMonitor )
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }

    func displayDialog(title: String, message: String) -> Void {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: .default)
            { (action:UIAlertAction!) in
                DispatchQueue.main.async
                    {
                        self.dismiss(animated: true, completion: nil)
                        
                }
            }
            
            alertController.addAction(OkAction)
            self.present(alertController, animated: true, completion:  nil)
        }
    }

    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    }

    // MARK: UITableViewDelegate extension
    extension AttendeeListViewController: UITableViewDelegate  {
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 25
        }
        
    }

// MARK: UITableViewDataSource extension
extension AttendeeListViewController: UITableViewDataSource  {

    
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return attendeesArray.count
            }
    
    
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! AttendeeListViewCell
        
                // Fetches the appropriate meal for the data source layout.
                let attendee = attendeesArray[indexPath.row]
        
                cell.name?.text = attendee.attendeeFirstName + " " + attendee.attendeeLastName
                cell.uid?.text = attendee.uid
        
                return cell
            }
    
}
