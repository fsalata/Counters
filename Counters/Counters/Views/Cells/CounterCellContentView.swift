//
//  CounterCellContentView.swift
//  Counters
//
//  Created by Fabio Salata on 10/04/22.
//

import UIKit

class CounterCellContentView: UIView, UIContentView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var currentConfiguration: UIContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? CounterCellConfiguration else {
                return
            }
            
            currentConfiguration = newConfiguration
        }
    }
    
    init(configuration: CounterCellConfiguration) {
        super.init(frame: .zero)
        
        let view = loadViewFromNib()
        addSubview(view)
        
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}

struct CounterCellConfiguration: UIContentConfiguration, Hashable {
    var title: String?
    var count: String?
    
    func makeContentView() -> UIView & UIContentView {
        return CounterCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> CounterCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        
        var updatedConfiguration = self
        
        return updatedConfiguration
    }
}
