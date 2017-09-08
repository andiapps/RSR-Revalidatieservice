//
//  PechhulpViewController.swift
//  RSR Revalidatieservice
//
//  Created by Diii workstation on 01/08/2017.
//  Copyright © 2017 Diii workstation. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PechhulpViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    //
    @IBOutlet weak var map: MKMapView!
    let locManager = CLLocationManager()
    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05) //zoom level
    let myPositionPin = MKPointAnnotation()
    var addressDetails = String()
    
    @IBOutlet weak var BelIcon: UIImageView!
    @IBOutlet weak var BelBtn: UIButton!
    
    @IBAction func popActionBtn(_ sender: Any) {
        self.map.deselectAnnotation(myPositionPin, animated: true)
        BelBtn.isHidden = true
        BelIcon.isHidden = true
        phoneCallPop.isHidden = false //Popover view status
    }
    
    @IBOutlet weak var phoneCallPop: UIView!
    @IBAction func MakingCalls(_ sender: Any) {
        //Number format function for enabling special characters
        let number = "+319007788990"
        let scanner = Scanner(string: number)
        
        let validCharacters = CharacterSet.decimalDigits
        let startCharacters = validCharacters.union(CharacterSet(charactersIn: "+#"))
        
        var digits: NSString?
        var validNumber = ""
        while !scanner.isAtEnd {
            if scanner.scanLocation == 0 {
                scanner.scanCharacters(from: startCharacters, into: &digits)
            } else {
                scanner.scanCharacters(from: validCharacters, into: &digits)
            }
            
            scanner.scanUpToCharacters(from: validCharacters, into: nil)
            if let digits = digits as String? {
                validNumber.append(digits)
            }
        }
        //Making the phone call. This function isn't supported on simulator
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //Function for closing down popup view and reset the background view controller
    @IBAction func closePopUp(_ sender: Any) {
         phoneCallPop.isHidden = true
         locManager.startUpdatingLocation()
         BelBtn.isHidden = false
         BelIcon.isHidden = false 
    }
    
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locaiton = locations[0] //Picking most recent position of the user
        
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locaiton.coordinate.latitude, locaiton.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        
        map.setRegion(region, animated: true) //Setting zoom-level on the map
        myPositionPin.coordinate = userLocation
        map.addAnnotation(myPositionPin)
        
        //Reverse geocoding
        CLGeocoder().reverseGeocodeLocation(locaiton) { (placemark, error) in
            if error != nil
            {
                print ("THERE WAS AN ERROR")
            }
            else
            {
                if let place = placemark?[0]
                {
                    if place.subThoroughfare != nil
                    {
                        self.addressDetails = "\(place.thoroughfare!),\(place.subThoroughfare!), \n \(place.postalCode!), \(place.locality!)"
                        self.map.selectAnnotation(self.myPositionPin, animated: true) //comment this part to disable auto populating callout
                    }
                }
            }
        }
    }
   //
   override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
    
        phoneCallPop.isHidden = true
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest   //GPS accuracy
            locManager.startUpdatingLocation()
            
        } else {
            
            let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in order to use this app. Settings are available in 'Settings' - 'Privacy'", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default,
                                         handler: nil)
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
    }

    }
    
    override func viewDidAppear(_ animated: Bool) {  //checking network connections 
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "Internet connection is required", message: "You are disconnected! Please check your network connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            //let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            //controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    //Applying customized callout view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let customView = (Bundle.main.loadNibNamed("CustomCallout", owner: self, options: nil))?[0] as! CustomCallout
        
        // Center the callout view over the annotation pin.
        var calloutViewFrame = customView.frame;
        calloutViewFrame.origin = CGPoint(x: -calloutViewFrame.size.width/2 + 15, y: -calloutViewFrame.size.height - 10);
        customView.frame = calloutViewFrame;
        customView.addressLbl.text = addressDetails
        view.addSubview(customView)
        locManager.stopUpdatingLocation() //Stop location updates and prevent auto zoom. Comment it out if not needed.
    }

    
    
    //Applying customized pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "marker.png")
            pin.canShowCallout = false
            
            return pin
        } else {
            
            
        }
        return nil
    }
    
    //Dismiss callout. *** Please uncomment this part if auto dismiss is needed
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
