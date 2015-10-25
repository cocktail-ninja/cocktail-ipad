//
//  PouringViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import iOSSharedViewTransition
import PromiseKit

class PouringViewController: UIViewController, ASFSharedViewTransitionDataSource {
    let SUCCESS_ANIMATION_DURATION = 2.0
    var imageSize: CGSize
    let pouringView: PouringView
    let successView: GlowingView
    let duration : Double
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(drink: Drink, duration: Double, imageSize: CGSize) {
        self.duration = duration
        self.imageSize = imageSize
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let screen = appDelegate.window!.frame.size
        let origin = CGPoint(
            x: (screen.width - imageSize.width) / 2,
            y: (screen.height - imageSize.height) / 2
        )
        let frame = CGRect(origin: origin, size: imageSize)
        pouringView = PouringView(frame: frame)
        successView = GlowingView(frame: frame)
        
        super.init(nibName: nil, bundle: nil)
        
        let drinkImage = drink.image();
        pouringView.setImage(drinkImage)
        successView.setImage(drinkImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(pouringView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animatePouring()
            .then(addSuccessView)
            .then(animateSuccess)
            .then(dismiss)
    }
    
    func animatePouring() -> Promise<Bool> {
        return pouringView.animate(duration)
    }
    
    func addSuccessView(finished: Bool) -> Promise<Bool> {
        view.addSubview(successView)
        return Promise<Bool>(true)
    }
    
    func animateSuccess(finished: Bool) -> Promise<Bool> {
        return successView.animate(SUCCESS_ANIMATION_DURATION)
    }
    
    func dismiss(finished: Bool) {
        let drinksController = self.navigationController!.viewControllers.filter {
            $0.isKindOfClass(DrinksViewController)
        }.first!
        self.navigationController?.popToViewController(drinksController, animated: true)
    }
    
    func sharedView() -> UIView! {
        return pouringView
    }    
}
