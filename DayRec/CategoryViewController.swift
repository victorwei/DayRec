//
//  CategoryViewController.swift
//  DayReco
//
//  Created by Victor Wei on 9/30/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray: [String]!
    var categorySelected: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the categories
        categoryArray = ["Alcohol", "Family", "Sightseeing", "Food", "Party", "Adventure", "Shopping"]
        //setup the tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "categoryID")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Use the default cell
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryID", forIndexPath: indexPath)
        cell.textLabel!.text = categoryArray[indexPath.row]
        cell.backgroundColor = UIColor(netHex: 0xF2F2F2)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //On the cell selected, set the category and perform the segue
        categorySelected = categoryArray[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("unwindToAddRecoVC", sender: self)
        
    }


}
