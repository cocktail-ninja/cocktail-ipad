import UIKit

class FixedIncrementSlider: UIControl {
    let slider: UISlider
    var increment: Float = 1
    var value: Float {
        set {
            setValue(newValue, animated: false)
        }
        get {
            return slider.value * increment
        }
    }
    
    override init(frame: CGRect) {
        var zeroFrame = frame;
        zeroFrame.origin = CGPointZero
        
        slider = UISlider(frame: zeroFrame)
        
        super.init(frame: frame)
        addSubview(slider)
        
        slider.addTarget(self, action: "sliderChanged", forControlEvents: .ValueChanged)
    }
    
    func setConfig(minimumValue minimumValue: Float, maximumValue: Float, increment: Float) {
        self.increment = increment
        slider.minimumValue = minimumValue / increment
        slider.maximumValue = maximumValue / increment
    }
    
    func sliderChanged() {
        value = floor(slider.value) * increment
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func setValue(value: Float, animated: Bool) {
        slider.setValue(value / increment, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}