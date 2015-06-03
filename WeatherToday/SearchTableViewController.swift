//
//  SearchTableViewController.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 01/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit


class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, CitiesLoaderDelegate {
    
    
    var cities = [City]()
    var stored_cities = [City]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.stored_cities = StoredCities.getStoredCities()
        self.tableView.reloadData()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.getSearchDisplayController().searchResultsTableView {
            return self.cities.count
        } else {
            return self.stored_cities.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        if tableView == self.getSearchDisplayController().searchResultsTableView {
            if (indexPath.row < cities.count) {
                cell.textLabel!.text = self.cities[indexPath.row].name;
            }
            
        } else {
            cell.textLabel!.text = self.stored_cities[indexPath.row].name;
        }

        return cell;
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.getSearchDisplayController().searchResultsTableView {
            StoredCities.saveCity(self.cities[indexPath.row].name!)
            StoredCities.deleteFirstIfMoreThan10()
        }
        self.performSegueWithIdentifier("weatherDetail", sender: tableView)

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

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "weatherDetail" {
            let weatherDetailViewController = segue.destinationViewController as! UIViewController
            if sender as! UITableView == self.getSearchDisplayController().searchResultsTableView {
                let indexPath = self.getSearchDisplayController().searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.cities[indexPath.row].name
                weatherDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.stored_cities[indexPath.row].name
                weatherDetailViewController.title = destinationTitle
            }
        }
    }

    
    func filterContentForSearchText(searchText: String) {
        
        
        if (count(searchText)<3) {
            return;
        }
        var citiesLoader : CitiesLoader = CitiesLoader()
        citiesLoader.delegate = self
        citiesLoader.load(searchText)
        
        
    }
    
    // MARK: - Cities loader delegate
    
    func citiesLoaded(cities: [City]) {
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.cities = cities
        self.getSearchDisplayController().searchResultsTableView.reloadData()
        //})

    }
    
    
    
    func getSearchDisplayController() -> UISearchDisplayController {
        return self.searchDisplayController!
    }
    
    // MARK: - UISearchDisplayController delegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    
    
}
