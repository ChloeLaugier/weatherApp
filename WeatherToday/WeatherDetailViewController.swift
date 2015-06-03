//
//  WeatherDetailViewController.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 02/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController, WeatherLoaderDelegate {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var observationTime: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    
    var refreshControl:UIRefreshControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefreshControl()
        self.scrollView.alpha = 0;
        self.refresh("");

    }
    
    func addRefreshControl() {
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.size.height+10)
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.backgroundColor = UIColor.blackColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.scrollView.addSubview(refreshControl)
    }
    
    
    func refresh(sender:AnyObject)
    {
        getWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUI(weather: Weather) {
        self.temperature.text = weather.temperature! + "°C"
        self.observationTime.text = "Updated: "+weather.observation_time!
        self.humidity.text = "Humidity: "+weather.humidity!
        self.weatherDescription.text = weather.weather_description
        self.refreshControl.endRefreshing()
        
        if (self.scrollView.alpha == 0) {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.alpha = 1.0
            })
        }
        if let checkedUrl = NSURL(string: weather.icon!) {
            self.downloadImage(checkedUrl)
        }
    }
    func getWeather() {
        var wl : WeatherLoader = WeatherLoader()
        wl.delegate = self
        wl.load(self.title!)
    }
    
    
    func weatherLoaded (weather: Weather) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateUI(weather);
        })
        
    }
    
    func weatherError (error : String) {
        var alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func downloadImage(url:NSURL){
        self.getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.weatherImage.image = UIImage(data: data!)
            }
        }
    }
    
    
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
