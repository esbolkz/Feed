//
//  DetailViewController.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 3/5/18.
//  Copyright © 2018 Yesbol Kulanbekov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedText: UITextView!
    
    var titleFeed: String = ""
    var textFeed: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTitle.text = titleFeed
        feedText.text = textFeed
        
    }

    
}
