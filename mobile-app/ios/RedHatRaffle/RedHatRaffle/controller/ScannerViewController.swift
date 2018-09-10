//
//  ViewController.swift
//  Red Hat Scanner
//

import UIKit
import AVFoundation
import AudioToolbox

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    let url = "http://red-hat-raffle.ngrok.io/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Scanner"
        view.backgroundColor = .white
        
        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
        
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                print("Error Device Input")
            }
            
        }
        
        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        
        view.addSubview(codeFrame)
        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue
        
        // TODO Play sound/visual after scan
        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
            
            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            
            AudioServicesPlaySystemSound(customSoundId)
        }
        
        // Stop capturing and hence stop executing metadataOutput function over and over again
        captureSession?.stopRunning()
        
        // Call the function which performs navigation and pass the code string value we just detected
        
        displayDetailsViewController(scannedCode: stringCodeValue.replacingOccurrences(of: "\n", with: ""))
        
//        if stringCodeValue.lowercased().range(of:"|") != nil {
//             displayDetailsViewController(scannedCode: stringCodeValue)
//        } else {
//            displayErrorDialog(title: "Wrong side!", message: "Please scan the other side of the badge.")
//            return
//        }
        
    }
    
    func displayDetailsViewController(scannedCode: String) {

        let attendeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "attendeeList") as!  AttendeeListViewController
        attendeeViewController.scannedCode = scannedCode
        insertScannedValue(scannedValue: scannedCode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.pushViewController(attendeeViewController, animated: true)
        }
       
    }
    
    func insertScannedValue(scannedValue: String) {
        
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
        let baseUrl = url + "raffle/scanAttendee/"
        
        // Add parameter
        let urlWithParams = baseUrl + scannedValue
       
        // URL Encode
        let escapedString = urlWithParams.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        // Create URL Ibject
        let myUrl = URL(string: escapedString!);
        
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
                guard let attendeeResponse =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    else { return }
                
                //get the json object and display success message
                
                    let attendee = Attendee(attendeeFirstName: attendeeResponse["firstName"] as! String, attendeeLastName: attendeeResponse["lastName"] as! String, uid: attendeeResponse["id"] as! String)
                    self.displayDialog(title: "Scan Successful", message: (attendee?.attendeeFirstName)! + " " + (attendee?.attendeeLastName)!)
                
                DispatchQueue.main.async{

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
                         alertController.dismiss(animated: true, completion: nil)
                        
                }
            }
            
            alertController.addAction(OkAction)
            self.present(alertController, animated: true, completion:  nil)
        }
    }
    
    func displayErrorDialog(title: String, message: String) -> Void {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: .default)
            { (action:UIAlertAction!) in
                DispatchQueue.main.async
                    {
                       alertController.dismiss(animated: true, completion: nil)
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
