//
//  RealCostViewController.swift
//  United-Way
//
//  Created by Sharaf Nazaar on 10/8/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class RealCostViewController: UIViewController {

    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var btnAddMember: UIButton!
    @IBOutlet weak var budgetsTableView: UITableView!
    @IBOutlet weak var btnSelectCounty: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblBudget.text = "Household Budget"
        lblBudget.sizeToFit()
        
        lblMembers.text = "Household Members"
        lblMembers.sizeToFit()
        
        btnAddMember.layer.cornerRadius = 5
        btnAddMember.layer.borderWidth = 1
        
        btnSelectCounty.layer.cornerRadius = 5
        btnSelectCounty.layer.borderWidth = 1

        let lightBlueColor = UIColor(red: 0.67, green: 0.84, blue: 0.98, alpha: 1)
        
        btnAddMember.layer.borderColor  = lightBlueColor.cgColor
        btnAddMember.tintColor = lightBlueColor
        
        btnSelectCounty.layer.borderColor  = lightBlueColor.cgColor
        btnSelectCounty.tintColor = lightBlueColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        self.budgetsTableView.sectionHeaderHeight = 70

    }
    
    func addTransparentView(frames: CGRect) {
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        
//        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.midX-100.0, y: frames.origin.y + frames.height + 5, width: 200, height: CGFloat(self.dataSource.count * 10))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    @IBAction func onClickSelectCounty(_ sender: Any) {
        dataSource = ["Alameda County",
                      "Alpine County",
                      "Amador County",
                      "Butte County",
                      "Calaveras County",
                      "Colusa County",
                      "Contra Costa County",
                      "Del Norte County",
                      "El Dorado County",
                      "Fresno County",
                      "Glenn County",
                      "Humboldt County",
                      "Imperial County",
                      "Inyo County",
                      "Kern County",
                      "Ventura County",
                      "Yolo County",
                      "Yuba County"]
        selectedButton = btnSelectCounty
        addTransparentView(frames: btnSelectCounty.frame)
    }
    
}

extension RealCostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}