//
//  itemCell.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 09/05/2021.
//

import UIKit

class itemCell: UITableViewCell {

    @IBOutlet var main: UIView!
    @IBOutlet var shadowLayer: ShadowView!
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var totalBoughtSpentLabel: UILabel!
    @IBOutlet var currentPriceLabel: UILabel!
    @IBOutlet var totalNowLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    @IBOutlet var platformIcon: UIImageView!
    @IBOutlet var amountStepper: UIStepper!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        cellTag = self.tag
        NotificationCenter.default.post(name: NSNotification.Name("editInvestment"), object: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        cellTag = self.tag
        NotificationCenter.default.post(name: NSNotification.Name("deleteInvestment"), object: nil)
    }
    @IBAction func stepperValueChanged(_ sender: Any) {
        cellTag = self.tag
        currentAmount = Int(self.amountStepper.value)
        NotificationCenter.default.post(name: NSNotification.Name("amountChangedInvestment"), object: nil)
    }
    
    @IBAction func rlInsiderChart(_ sender: Any) {
        cellTag = self.tag
        NotificationCenter.default.post(name: NSNotification.Name("showRLInsiderChart"), object: nil)
    }
    
    @IBAction func groupButtonPressed(_ sender: Any) {
        cellTag = self.tag
        NotificationCenter.default.post(name: NSNotification.Name("groupInvestment"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        
    }
    
    func setupView()
    {
        self.main.layer.cornerRadius = 8
        self.main.layer.masksToBounds = true

        self.shadowLayer.layer.masksToBounds = false
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.23
        self.shadowLayer.layer.shadowRadius = 4
        
        self.shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: self.shadowLayer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.shadowLayer.layer.shouldRasterize = true
        self.shadowLayer.layer.rasterizationScale = UIScreen.main.scale
    }

}

class ShadowView: UIView {
    
    override func layoutSubviews() {
            super.layoutSubviews()
            setupShadow()
        }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.23
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
