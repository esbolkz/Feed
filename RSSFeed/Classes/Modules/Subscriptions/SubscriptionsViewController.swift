//
//  SubscriptionsSubscriptionsViewController.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 03/03/2018.
//  Copyright © 2018 Lobster. All rights reserved.
//

import UIKit
import FeedKit


class SubscriptionsViewController: UIViewController {

    var feeds = [Feed]()
    var parsers = [FeedParser]()

    
    @IBOutlet weak var feedTable: UITableView!
    override func viewDidLoad() {
        title = "RSS Feeds"
        updateNavBarButton()
        
        //createParsers()
        
        feedTable.dataSource = self
        feedTable.delegate   = self
        


        FeedFinder.shared.loadDefaults() { [weak self] (feeds) in
            self?.feeds = feeds

            DispatchQueue.main.async {

                self?.feedTable.reloadData()
            }

            self?.parsers = feeds.map { (feed: Feed) in
                let feedURL = URL(string: feed.feedURL)!
                let parser = FeedParser(URL: feedURL)!
                return parser
            }


        }

        
        

        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = feedTable.indexPathForSelectedRow!
        if (segue.identifier == "toPosts") {
            if let vc = segue.destination as? FeedPostsTableViewController {
                
                
                vc.feedStringURL = feeds[indexPath.row].feedURL
                vc.parser = parsers[indexPath.row]
            }
        }
    }
    
    @objc func search(){
        print("Search")
    }
    
    private func updateNavBarButton() {
        let searchButton  = UIBarButtonItem(title: "Search",
                                          style: .done,
                                          target: self,
                                          action: #selector(search))
        navigationItem.rightBarButtonItem = searchButton
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }


}


extension SubscriptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
        cell.textLabel?.text = feeds[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}

extension SubscriptionsViewController: UITableViewDelegate {
    
}
