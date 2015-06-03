//
//  WeatherLoader.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 03/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit


protocol WeatherLoaderDelegate {
    func weatherLoaded (weather: Weather)
    func weatherError (error : String)
}

class WeatherLoader: NSObject {
    
    var delegate : WeatherLoaderDelegate?
    let apiWeather : String = "http://api.worldweatheronline.com/free/v2/weather.ashx?key=01ba816af6ea99a383d63ed17bf9d"
    
    
    func load(cityname : String) {
        
        
        var cityEscaped = cityname.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var postEndpoint: String = apiWeather+"&q="+cityEscaped!+"&fx=yes&format=json"
        var urlRequest = NSURLRequest(URL: NSURL(string: postEndpoint)!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error
            {
                println("error worldweatheronline")
            }
            else
            {
                var jsonError: NSError?
                let jsonWeather = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError
                {
                    println("error parsing")
                }
                else
                {
                    var data : NSDictionary = jsonWeather["data"] as! NSDictionary;
                    
                    if let current_condition_array = data["current_condition"] as? NSArray {
                        
                        var weather : Weather = Weather()
                        weather.completeWithJson(current_condition_array)
                        
                        self.delegate?.weatherLoaded(weather)
                        
                    }
                    else  {
                        
                        var msg : String = "Unable to find any matching weather location to the query submitted!"
                        if let errormsgarray = data["error"] as? NSArray {
                            
                            var errormsg : NSDictionary = errormsgarray[0] as! NSDictionary
                            var msg: String = errormsg["msg"] as! String
                        }
                        
                        self.delegate?.weatherError(msg)
                        
                       
                        
                    }
                    
                    
                    
                }
            }
        })

        
        
        
    }
   
}
