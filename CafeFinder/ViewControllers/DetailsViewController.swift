//
//  DetailsViewController.swift
//  ViperSample
//
//  Created by tutkubide on 25.10.2020.
//

import UIKit
import MapKit
import Alamofire
import FoursquareAPIClient
import SDWebImage
import CoreLocation
import MBProgressHUD

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  
    var tipsArray : [String] = []
    var selectModel: VenuesModel!
    var userManager = CLLocationManager()
    var requestLocation = CLLocation()
    var nameString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        userManager.delegate = self
        userManager.desiredAccuracy = kCLLocationAccuracyKilometer
        userManager.requestWhenInUseAuthorization()
        nameLabel.text = nameString
        getPhotos()
    }
    
    func getPhotos() {
        let url: String = "https://api.foursquare.com/v2/venues/"+(selectModel?.id ?? "")+"/photos?client_id=TVC22TPDEIBP1XIFTHG2W5YMKBO5GU0JQ5N1GVR2SEGOQBLL&client_secret=KHJZIJ030RH1R4ZFWYUM1ZHJK25XAKHNSY3GXDV55RW00AIN&v=20190521"
        ApiManager.shared.fetchData(url) { (success, response) in
            if success {
                let json = response.value
                let jsonDictionary = json as! NSDictionary
                let response = jsonDictionary["response"] as! NSDictionary
                let photosModel = response["photos"] as! NSDictionary
                let items = photosModel["items"] as! NSArray
                let object = items[0]
                let model = object as! NSDictionary
                var photos = ""
                photos = (model["prefix"] as! String) + "414x268"+(model["suffix"] as! String)
                self.imageview.sd_setImage(with: URL(string: photos))
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
        getLists()
    }
    
    func getLists() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let url : String = "https://api.foursquare.com/v2/venues/"+(selectModel?.id ?? "")+"/tips?client_id=TVC22TPDEIBP1XIFTHG2W5YMKBO5GU0JQ5N1GVR2SEGOQBLL&client_secret=KHJZIJ030RH1R4ZFWYUM1ZHJK25XAKHNSY3GXDV55RW00AIN&v=20190521"
        print(url)
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let tipsModel = responseModel["tips"] as! NSDictionary;
                let tipsItemsArray = tipsModel["items"] as! NSArray;
                for object in tipsItemsArray {
                    let model = object as! NSDictionary;
                    let tipsText = (model["text"] as! String)
                    self.tipsArray.append(tipsText);
                }
                self.tipsLabel.text = self.tipsArray[0]
                MBProgressHUD.hide(for: self.view, animated: true)
                self.userManager.startUpdatingLocation()
                self.mapViewAnnotationCustomize()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .orange
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.selectModel.lat != 0 && self.selectModel.lng != 0 {
            self.requestLocation = CLLocation(latitude: self.selectModel.lat, longitude: self.selectModel.lng)
        }
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placesmark = placemarks {
                if placesmark.count > 0 {
                    let newPlacesmark = MKPlacemark(placemark: placesmark[0])
                    let item = MKMapItem(placemark: newPlacesmark)
                    item.name = self.tipsLabel.text
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
    func mapViewAnnotationCustomize() {
        let location = CLLocationCoordinate2D(latitude: self.selectModel.lat, longitude: self.selectModel.lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        annotation.title = self.nameLabel.text
    }
}
