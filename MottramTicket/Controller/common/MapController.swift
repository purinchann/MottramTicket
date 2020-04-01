//
//  MapController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/09.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
    var lat: Double = 33.585734
    var lng: Double = 130.394709
    
    let pageTitle: String = "支払い&タピオカ受け渡し場所"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pageTitle
        setupMapView()
    }
    
    func setupMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat,                                                      longitude: lng, zoom: 20)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat,lng)
        marker.title = pageTitle
        marker.snippet = "Fukuoka"
        marker.map = mapView
    }
}
