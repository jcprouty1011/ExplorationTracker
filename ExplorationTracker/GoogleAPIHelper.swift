//
//  GoogleAPIHelper.swift
//  ExplorationTracker
//
//  Created by Jeffrey Prouty on 8/11/18.
//  Copyright © 2018 Jeffrey Prouty. All rights reserved.
//

import UIKit
import GoogleMaps

struct GoogleAPIHelper {
    
    static func requestSnappedPoint(location: CLLocation) {
        let baseURL = "https://roads.googleapis.com/v1/snapToRoads?"
        let appendString = "path=\(String(location.coordinate.latitude)),\(String(location.coordinate.longitude))"
        let fullURLString = baseURL + appendString + "&key=AIzaSyBeXYjZ7Rdi4rOWu5Sg_osx5y_1-8LLiK4"
        
        if let url = URL(string: fullURLString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let rawJson = try? JSONSerialization.jsonObject(with: data), let json = rawJson as? [String: Any] {
                    print("Raw JSON")
                    print(rawJson)
                    if let snappedPointDictionary = json["snappedPoints"] as? [[String: Any]] {
                        let coordinateDictionary = snappedPointDictionary[0]["location"]! as! [String: Double]
                        let coordinates = (coordinateDictionary["latitude"]!, coordinateDictionary["longitude"]!)
                        print("Coordinates: \(coordinates)")
                    } else {
                        print("Could not convert points to [String: Any]")
                    }
                    
                } else {
                    print("Json serialization failed")
                }
            }
            task.resume()
        } else {
            print("URL Construction from string provided failed.")
        }
        
    }
    
    //Currently not functional - URLs can't have | but server side seems to require it for lists
    static func requestSnappedPoints(locationList: [CLLocation]) {
        let baseURL = "https://roads.googleapis.com/v1/snapToRoads?"
        let coordinatePairs: [(Double, Double)] = locationList.map{($0.coordinate.latitude, $0.coordinate.longitude)}
        
        //With "." in place of the "|" character for proper URL encoding
        let pairString = coordinatePairs.reduce("") {$0 + "|" + String($1.0) + "," + String($1.1)}
        let appendString = "path=" + pairString[pairString.index(pairString.startIndex, offsetBy: 1)..<pairString.endIndex]
        let fullURLString = baseURL + appendString + "&key=AIzaSyBeXYjZ7Rdi4rOWu5Sg_osx5y_1-8LLiK4"
        print(fullURLString)
        
        if let url = URL(string: fullURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("here")
                if let data = data, let rawJson = try? JSONSerialization.jsonObject(with: data), let json = rawJson as? [String: Any] {
                    print("Raw JSON")
                    print(rawJson)
                    if let snappedPointDictionary = json["snappedPoints"] as? [[String: Any]] {
                        print(snappedPointDictionary[0]["location"])
                    } else {
                        print("Could not convert points to [String: Any]")
                    }
                    
                } else {
                    print("Json serialization failed")
                }
            }
            task.resume()
        } else {
            print("URL Construction from string provided failed.")
        }
    }
}
