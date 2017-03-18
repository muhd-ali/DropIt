//
//  DropIt.swift
//  DropIt
//
//  Created by Muhammadali on 19/03/2017.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit
import CoreMotion

class DropItView: UIImageView {
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    private let gravity = UIGravityBehavior()
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    var realGravity = false {
        didSet {
            updateRealGravity()
        }
    }
    
    private let motionManager = CMMotionManager()
    private func updateRealGravity() {
        if realGravity {
            if motionManager.isAccelerometerAvailable && !motionManager.isAccelerometerActive {
                motionManager.accelerometerUpdateInterval = 0.25
                motionManager.startAccelerometerUpdates()
                motionManager.startAccelerometerUpdates(to: .main, withHandler: { [weak weakSelf = self] (data, error) in
                    if let dx = data?.acceleration.x, let dy = data?.acceleration.y {
                        weakSelf?.gravity.gravityDirection = CGVector(dx: dx, dy: -dy)
                    }
                })
            }
        } else {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    var blocksAreAnimating = false {
        didSet {
            if blocksAreAnimating {
                animator.addBehavior(gravity)
                animator.addBehavior(collider)
            } else {
                animator.removeBehavior(gravity)
                animator.addBehavior(collider)
            }
        }
    }
    
    
    private let blocksPerRow = 5
    private let maxBlocks = 15
    private var currentBlocks = 0
    
    private var blockSize: CGSize {
        let bSize = bounds.size.width / CGFloat(blocksPerRow)
        return CGSize(width: bSize, height: bSize)
    }
    
    func addBlock() {
        if currentBlocks < maxBlocks {
            currentBlocks += 1
            var frame = CGRect(origin: CGPoint.zero, size: blockSize)
            frame.origin.x = CGFloat(arc4random() % UInt32(blocksPerRow)) * blockSize.width
            
            let block = UIVisualEffectView(frame: frame)
            let blurEffect = UIBlurEffect(style: .light)
            block.effect = blurEffect
            
            addSubview(block)
            gravity.addItem(block)
            collider.addItem(block)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
    }
}
