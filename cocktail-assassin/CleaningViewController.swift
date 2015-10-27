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
    var buttonsEnabled: Bool = true
    var seconds: Int = 30
    
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
            return cell
        case .Valves:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComponentCell", forIndexPath: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let valve = valves[indexPath.row]
            cell.update(valve)
            cell.button.enabled = buttonsEnabled
            return cell
        case .Pumps:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComponentCell", forIndexPath: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let pump = pumps[indexPath.row]
            cell.update(pump)
            cell.button.enabled = buttonsEnabled
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
    
    func componentClicked(component: Component) {
        print("Component: \(component.name) clicked!")
        disableButtons()
        let flowrate = component.type == .Valve ? 52 : 2
        let ml = seconds * flowrate
        DrinkService.makeDrink(recipe: "\(component.id)-\(ml)").then { duration in
            self.performSelector("enableButtons", withObject: nil, afterDelay: duration)
        }.error { error in
            self.enableButtons()
        }
    }
    
    func enableButtons() {
        buttonsEnabled = true
        self.collectionView!.reloadData()
    }
    
    func disableButtons() {
        buttonsEnabled = false
        self.collectionView!.reloadData()
    }
    
}