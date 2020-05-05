//
//  BenefitDetailController.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 4/30/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct BenefitDetailModel:Decodable {
    let benefitName:String
    let benefitAmount:Int
    let benefitEligibility:String?
}

class BenefitDetailController: UIViewController {
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var websiteTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    var benefitName : String! = ""
   
    override func viewDidLoad() {
           super.viewDidLoad()
        
        nameTitleLabel.text = benefitName
        
           let locationCenter = CLLocation(latitude: 33.761240, longitude: -117.8947695)
        
//        let region = MKCoordinateRegion(
//             center: locationCenter.coordinate,
//             latitudinalMeters: 800,
//             longitudinalMeters: 800)
//           mapView.setCameraBoundary(
//             MKMapView.CameraBoundary(coordinateRegion: region),
//             animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCenter.coordinate
        annotation.title = benefitName
        mapView.addAnnotation(annotation)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 120000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate,
                                latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
       }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
