//
//  DropItViewController.swift
//  DropIt
//
//  Created by Muhammadali on 19/03/2017.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {

    @IBOutlet weak var dropItView: DropItView! {
        didSet {
            dropItView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBlock(recognizer:))))
        }
    }
    
    func addBlock(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            dropItView.addBlock()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropItView.blocksAreAnimating = true
        dropItView.realGravity = true
    }
    
}
