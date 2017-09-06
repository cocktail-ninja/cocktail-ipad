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
        case slider = 0
        case valves = 1
        case pumps = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cleaning"
        
        valves = Component.componentsOfType(.valve, managedContext: coreDataStack.context)
        pumps = Component.componentsOfType(.pump, managedContext: coreDataStack.context)
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CleaningSection(rawValue: section)! {
        case .slider:
            return 1
        case .valves:
            return valves.count
        case .pumps:
            return pumps.count
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch CleaningSection(rawValue: indexPath.section)! {
        case .slider:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCollectionCell
            if cleaningInProgress {
                cell.animateProgressWithDuration(Double(seconds))
            } else {
                cell.showSlider()
            }
            return cell
        case .valves:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComponentCell", for: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let valve = valves[indexPath.row]
            cell.update(valve)
            cell.buttonEnabled = !cleaningInProgress
            return cell
        case .pumps:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComponentCell", for: indexPath) as! ComponentCollectionCell
            cell.delegate = self
            let pump = pumps[indexPath.row]
            cell.update(pump)
            cell.buttonEnabled = !cleaningInProgress
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        switch CleaningSection(rawValue: indexPath.section)! {
        case .slider:
            return CGSize(width: view.frame.size.width - 40, height: 80)
        case .valves:
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
            return CGSize(width: width, height: 100)
        case .pumps:
            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
            return CGSize(width: width, height: 100)
        }
    }
    
    @IBAction func sliderChanged(_ slider: UISlider) {
        seconds = Int(slider.value)
        let cell = self.collectionView!.cellForItem(at: IndexPath(row: 0, section: 0)) as! SliderCollectionCell
        cell.sliderLabel.text = "Run for \(seconds) seconds"
    }
    
    func componentSelected(_ component: Component) {
        // do nothing...
    }
    
    @IBAction func runSelectedPumpsClicked() {
        let valveRecipe = valves.filter { $0.selected }.map() { "\($0.id)-\(self.seconds * 52)" }
        let pumpRecipe = pumps.filter { $0.selected }.map() { "\($0.id)-\(self.seconds * 2)" }
        let recipe = (valveRecipe + pumpRecipe).joined(separator: "/")
        
        DrinkService.makeDrink(recipe: recipe).then() { duration -> Void in
            self.seconds = Int(duration)
            self.cleaningInProgress = true
            self.collectionView?.reloadData()
            self.perform(#selector(self.cleaningFinished), with: nil, afterDelay: duration)
        }.catch { error in
            print("What is ErrorType ?? \(error)")
            self.cleaningFinished()
        }
    }
    
    func cleaningFinished() {
        cleaningInProgress = false
        collectionView?.reloadData()
    }
    
}
