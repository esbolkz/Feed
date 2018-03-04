//
//  FeedPostsTableViewController.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 3/4/18.
//  Copyright © 2018 Yesbol Kulanbekov. All rights reserved.
//

import UIKit
import FeedKit

class FeedPostsTableViewController: UITableViewController {
    
    var parser: FeedParser?
    var feedStringURL: String?
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            DispatchQueue.main.async {

                print("Result is ")
                switch result {
                case let .atom(feed):

                    self.title = feed.title ?? ""
                    if let items = feed.entries{
                        self.posts = items.map {
                            let post = Post(title: $0.title!, description: ($0.summary?.value) ?? "No content")
                            return post
                        }
                    } else {
                        break
                    }


                case let .rss(feed):
                    self.title = feed.title ?? ""

                    if let items = feed.items {
                        self.posts = items.map {
                            let descr = ($0.description) ?? "No rss content"
                            let str = descr.replacingOccurrences(of: "<[^>]+>",
                                                                 with: "",
                                                                 options: .regularExpression,
                                                                 range: nil)
                            //("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)

                            let post = Post(title: $0.title!, description: str)
                            return post
                        }
                    } else{
                        break
                    }
                case let .json(feed):
                    self.title = feed.title ?? ""
                    if let items = feed.items {
                        self.posts = items.map {
                            let post = Post(title: $0.title!, description: $0.summary!)
                            return post
                        }
                    } else{
                        break
                    }
                    
                case let .failure(error):
                    self.title = "No items"
                    
                    print(error)
                }
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        if (segue.identifier == "toDetail") {
            if let vc = segue.destination as? DetailViewController {
                let post = posts[indexPath.row]
                vc.titleFeed = post.title
                vc.textFeed = post.description
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPosts", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}

struct Post {
    let title: String
    let description: String
}


