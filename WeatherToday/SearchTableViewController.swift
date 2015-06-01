//
//  SearchTableViewController.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 01/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    var cities = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
          
            return self.cities.count
        } else {
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            if (indexPath.row < cities.count) {
                cell.textLabel!.text = self.cities[indexPath.row];
            }
            else {
                cell.textLabel!.text =  "";
            }
            
            
            
            
        } else {
            cell.textLabel!.text = "not yet";
        }

        return cell;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func filterContentForSearchText(searchText: String) {
        
        
        if (count(searchText)<3) {
            return;
        }
        var searchTextEscaped = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var postEndpoint: String = "http://gd.geobytes.com/AutoCompleteCity?q="+searchTextEscaped!
        var urlRequest = NSURLRequest(URL: NSURL(string: postEndpoint)!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error
            {
                println("error calling geobytes")
            }
            else
            {
                var jsonError: NSError?
                let jsonCities = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSArray
                if let aJSONError = jsonError
                {
                    println("error parsing")
                }
                else
                {
                    self.cities = [];
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.searchDisplayController!.searchResultsTableView.reloadData()
                    })
                    for city in jsonCities {
                        self.cities.append(city as! String);
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.searchDisplayController!.searchResultsTableView.reloadData()
                    })
                    
                }
            }
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

}
