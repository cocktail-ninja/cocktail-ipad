import UIKit
import iOSSharedViewTransition
import PromiseKit

class DrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource, UITableViewDataSource, UITableViewDelegate {
    let drinkImageView = UIImageView(frame: Constants.drinkFrames.expandedFrame),
        backButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        pourButton = StartPouringButton(frame: CGRectMake(620, 650, 300, 60)),
        resetIngredientButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        ingredientsTableView = UITableView();
    
    var drink: Drink?
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(drink: Drink) {
        super.init()
        self.drink = drink
                
        drinkImageView.frame = Constants.drinkFrames.expandedFrame
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = UIImage(named: drink.imageName)
        
        
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.setTitle("  Back", forState: .Normal)
        backButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        backButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        backButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        backButton.frame = CGRectMake(30, 30, 100, 60)
        
        
        ingredientsTableView.frame = CGRectMake(400, 180, 550, 450)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.scrollEnabled = false
        ingredientsTableView.separatorStyle = .None
        ingredientsTableView.allowsSelection = false
        view.addSubview(ingredientsTableView)
        
        
        resetIngredientButton.setImage(UIImage(named: "reset.png"), forState: UIControlState.Normal)
        resetIngredientButton.setTitle("  Reset ingredients", forState: .Normal)
        resetIngredientButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(16))
        resetIngredientButton.frame = CGRectMake(620, 590, 300, 60)
        resetIngredientButton.backgroundColor = UIColor.clearColor()
        resetIngredientButton.setTitleColor(ThemeColor.primary, forState: .Normal)
        resetIngredientButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        resetIngredientButton.titleLabel?.textAlignment = .Center
        view.addSubview(resetIngredientButton)
        
        var label = UILabel(frame: CGRectMake(500, 100, 500, 50))
        label.text = drink.name
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .Center
        view.addSubview(label)
        
        resetIngredientButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drink!.drinkIngredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? DrinkIngredientCell
        if(cell == nil) {
            cell = DrinkIngredientCell(style: .Default, reuseIdentifier: "CELL")
        }
        
        var drinkIngredient = drink?.drinkIngredients.allObjects[indexPath.row] as DrinkIngredient
        
        cell!.displayDrinkIngredient(drinkIngredient)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(drinkImageView)
        view.addSubview(pourButton)
        view.addSubview(backButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewDidAppear")
    }
    
    func reset(){
        Drink.revert()
        ingredientsTableView.reloadData()
    }
    
    func dismiss(){
        Drink.revert()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func pour(){
        let ingredients = drink!.drinkIngredients.allObjects.map { $0 as DrinkIngredient }
        let recipe = "/".join(ingredients.map {"\($0.ingredient.pumpNumber)-\($0.amount)"})
        let promise = DrinkService.makeDrink(recipe: recipe)
     
        pourButton.setState(.Loading)
        promise.then({ (duration: Double) -> Promise<Void>? in
            Drink.revert()
            self.startPourAnimation(duration)
            return nil
        }).catch({ (error: NSError) -> Promise<Void>? in
            self.pourButton.setState(.Error)
            return nil
        })


    }
    
    func startPourAnimation(duration: Double) {
        var pouringVC = PouringViewController(drink: drink!, duration: duration)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        return drinkImageView
    }
}