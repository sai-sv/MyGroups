//
//  RatingControl.swift
//  
//
//  Created by Admin on 21.11.2019.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    // MARK: - Control properties
    var rating = 0 {
        didSet {
            updateButtonsState()
        }
    }
    private var ratingButtons = [UIButton]()
    
    // MARK: - Interface Builder properties
    @IBInspectable var starCount: Int = Int(5) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var size: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // MARK: - Control methods
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: sender) else { return }
        
        let newRating = index + 1
        rating = newRating == rating ? 0 : newRating
    }
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        

        // для корректного отображения в InterfaceBuilder'е
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.selected, .highlighted])
            
            // constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        updateButtonsState()
    }
    
    func updateButtonsState() {
        
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }

}
