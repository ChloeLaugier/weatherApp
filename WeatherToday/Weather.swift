//
//  Weather.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 03/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit

class Weather: NSObject {
    
    var temperature  : String?
    var observation_time : String?
    var humidity : String?
    var weather_description : String?
    var icon : String?
    
    
    func completeWithJson (current_condition_array : NSArray) {
        if (current_condition_array.count < 1) {
            return
        }
        var current_condition : NSDictionary = current_condition_array[0] as! NSDictionary
        if ((current_condition["FeelsLikeC"] as? String) != nil) {
            self.temperature = current_condition["FeelsLikeC"] as? String
        }
        if ((current_condition["humidity"] as? String) != nil) {
            self.humidity = current_condition["humidity"] as? String
        }
        
        if (current_condition["observation_time"] as? String
            != nil) {
                self.observation_time = current_condition["observation_time"] as? String}
        
        
        if (current_condition["weatherIconUrl"] as? NSArray != nil) {
            var icon_array: NSArray = current_condition["weatherIconUrl"] as! NSArray
            var icon_dic : NSDictionary = icon_array[0] as! NSDictionary;
            self.icon = icon_dic["value"] as? String;
        }
        
       
        
        if ((current_condition["weatherDesc"] as? NSArray
) != nil) {
            var weatherDesc_array: NSArray = current_condition["weatherDesc"] as! NSArray
            var weatherDesc_dic : NSDictionary = weatherDesc_array[0] as! NSDictionary;
            self.weather_description = weatherDesc_dic["value"] as? String;
        }
        
    }
   
}
