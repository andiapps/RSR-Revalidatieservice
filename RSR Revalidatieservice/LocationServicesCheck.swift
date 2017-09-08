//
//  LocationServicesCheck.swift
//  RSR Revalidatieservice
//
//  Created by Diii workstation on 24/08/2017.
//  Copyright © 2017 Diii workstation. All rights reserved.
//

import Foundation
import CoreLocation

open class LocationServicesCheck {
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
}
