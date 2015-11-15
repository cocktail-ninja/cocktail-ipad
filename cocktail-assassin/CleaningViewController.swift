//
//  CleaningViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import Foundation
import UIKit

class CleaningViewController: UICollectionViewController, ComponentCollectionCellDelegate {
    let stepSize: Float = 1.0
    let MARGIN = 20
    
    var coreDataStack: CoreDataStack!
    var valves: [Component]!
    var pumps: [Component]!
    var seconds: Int = 30
    var cleaningInProgress: Bool = false
    
    enum CleaningSection: Int {
        case Slider = 0
        case Valves = 1
        case Pumps = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cleaning"
        
        valves = Component.componentsOfType(.Valve, managedContext: coreDataStack.context)
        pumps = Component.componentsOfType(.Pump, managedContext: coreDataStack.context)
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CleaningSection(rawValue: section)! {
        case .Slider:
            return 1
        case .Valves:
            return valves.count
        case .Pumps:
            return pumps.count
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch CleaningSection(rawValue: indexPath.section)! {
        case .Slider:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCollectionCell
            if cleaningInProgress {
                cell.animateProgressWithDuration(Double(seconds))
            } else {
                cell.showSlider()
            }
            return cell
        case .Valves:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComponentCell", forIndexPath: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let valve = valves[indexPath.row]
            cell.update(valve)
            cell.buttonEnabled = !cleaningInProgress
            return cell
        case .Pumps:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComponentCell", forIndexPath: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let pump = pumps[indexPath.row]
            cell.update(pump)
            cell.buttonEnabled = !cleaningInProgress
            return cell
        }

    }
    
    @IBAction func sliderChanged(slider: UISlider) {
        seconds = Int(slider.value)
        let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SliderCollectionCell
        cell.sliderLabel.text = "Run for \(seconds) seconds"
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch CleaningSection(rawValue: indexPath.section)! {
        case .Slider:
            return CGSize(width: view.frame.size.width - 40, height: 80)
        case .Valves:
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
            return CGSize(width: width, height: 100)
        case .Pumps:
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
            return CGSize(width: width, height: 100)
        }
    }
    
    func componentSelected(component: Component) {
        // do nothing...
    }
    
    @IBAction func runSelectedPumpsClicked() {
        let valveRecipe = valves.filter { $0.selected }.map() { "\($0.id)-\(self.seconds * 52)" }
        let pumpRecipe = pumps.filter { $0.selected }.map() { "\($0.id)-\(self.seconds * 2)" }
        let recipe = (valveRecipe + pumpRecipe).joinWithSeparator("/")
        
        DrinkService.makeDrink(recipe: recipe).then() { duration -> Void in
            self.seconds = Int(duration)
            self.cleaningInProgress = true
            self.collectionView?.reloadData()
            self.performSelector("cleaningFinished", withObject: nil, afterDelay: duration)
        }.error() { error in
            print("What is ErrorType ?? \(error)")
            self.cleaningFinished()
        }
    }
    
    func cleaningFinished() {
        cleaningInProgress = false
        collectionView?.reloadData()
    }
    
}