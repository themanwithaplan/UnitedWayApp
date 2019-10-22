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

    @IBOutlet weak var btnSelectCounty: UIButton!
    @IBOutlet weak var textContainer: UITextView!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        let textURL = URL(string: "http://bing.benefitkitchen.com/api/bing?address=11215&persons[0][age]=32&persons[1][age]=12")!
        // URLSession is starting a request to the URL we stored inside "imageURL"
         let task = URLSession.shared.dataTask(with: textURL) {(data, response, error) in
             //Checking to see if there is an error
             if error == nil{
               let loadedText = UITextView()
                 self.textContainer = loadedText
             }
             
             
             
             
         }
         task.resume()
        
    }
    
    
    func addTransparentView(frames: CGRect) {
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 10))
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
                      "Colusa County","Contra Costa County",
                      "Del Norte County","El Dorado County","Fresno County","Glenn County","Humboldt County",
                      "Imperial County","Inyo County","Kern County","Ventura County","Yolo County","Yuba County"]
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
