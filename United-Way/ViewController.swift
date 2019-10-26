//
//  ViewController.swift
//  United Way
//
//  Created by ARNAV SINGHANIA on 10/24/19.
//  Copyright © 2019 ARNAV SINGHANIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CountyTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var OutputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiTestCalls()
        
    }

    private func apiTestCalls() {

        let url = URL(string: "https://bing.benefitkitchen.com/api/bing?address=11215&persons[0][age]=32&persons[1][age]=12%22")! 
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    print(json)
                
                    var jsonString = ""
                    
                    for (key, value) in json {
                        jsonString.append(contentsOf: key)
                        jsonString.append("=")
                        jsonString.append(String(describing: value))
                        jsonString.append(contentsOf: ", ")
                    }
                
                    DispatchQueue.main.async {
                        self.OutputTextView.text = jsonString
                    }

                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
    }

    @IBAction func SubmitButtonPressed(_ sender: UIButton) {
        
         // test statement
        
        print("In SubmitButtonPressed")
        
        //
        
        if let county = CountyTextField.text {
            if let ageString = AgeTextField.text {
                
                // test statements
                
                    print("\(county)")
                    print("\(ageString)")
                
                //
                
                var realCostMeasureData = RealCostMeasureWrapper(county: county, age: [Int(ageString)!])
                
                //make necessary calls to the database and extract information to display
                
            }
        }
        
    }
    
}

