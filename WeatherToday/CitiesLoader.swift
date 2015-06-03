//
//  CitiesLoader.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 03/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit


protocol CitiesLoaderDelegate {
    func citiesLoaded (cities : [City])
}


class CitiesLoader: NSObject, NSURLConnectionDelegate{
    
    
    var data: NSMutableData = NSMutableData()
    var connection : NSURLConnection = NSURLConnection();
    let geobytes : String = "http://gd.geobytes.com/AutoCompleteCity?q="
    var delegate:CitiesLoaderDelegate?
    

    func load(searchText : String) {
        var searchTextEscaped = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var postEndpoint: String = self.geobytes+searchTextEscaped!
        var urlRequest = NSURLRequest(URL: NSURL(string: postEndpoint)!)
        connection.cancel();
        connection = NSURLConnection(request: urlRequest, delegate: self, startImmediately: true)!
        
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
      
        var jsonError: NSError?
        let jsonCities = NSJSONSerialization.JSONObjectWithData(self.data, options: nil, error: &jsonError) as! NSArray
        if let aJSONError = jsonError
        {
            println("error parsing")
        }
        else
        {
            var cities : [City] = [];
            for cityjson in jsonCities {
                var city  : City = City(name : cityjson as! String)
                cities.append(city);
            }
            self.delegate?.citiesLoaded(cities)
            
                        
        }
    }
   
}
