//
//  SectionHeaderView.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-18.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit

protocol SectionHeaderViewDelegate: class, NSObjectProtocol{
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int)
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int)
}

class SectionHeaderView: UITableViewHeaderFooterView {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: SectionHeaderViewDelegate
    var section: Int!
    var HeaderOpen: Bool = false
    
    init(delegate: SectionHeaderViewDelegate, section: Int!, HeaderOpen: Bool) {
        self.delegate = delegate
        self.section = section
        self.HeaderOpen = HeaderOpen
    }
    
    override func awakeFromNib() {
        
        //disclosureButton image when open
        self.disclosureButton.setImage(UIImage(named: "Open"), for: UIControl.State.selected)
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "ButtonTapped")
        
        self.addGestureRecognizer(tapGesture)
    }
    
    
    @IBAction func ButtonTapped(_ sender: Any) {
        self.ButtonOpen(userAction: true)
    }
    
    func ButtonOpen(userAction: Bool){
        self.disclosureButton.isSelected = !self.disclosureButton.isSelected
        if(userAction){
            if(HeaderOpen){
                delegate.sectionHeaderView(sectionHeaderView: self, sectionClosed: section)
            }
            else{
                delegate.sectionHeaderView(sectionHeaderView: self, sectionOpened: section)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
