//
//  QuestionsVC.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit
import Foundation

class QuestionsVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tipsTxt: UITextField!
    @IBOutlet weak var hoursTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tipsTxt.delegate = self
        hoursTxt.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = true
        tipsTxt.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) { }

    @IBAction func proceed(_ sender: Any) {
        guard let tips = tipsTxt.text else { return }
        guard let hours = hoursTxt.text else { return }
        if tips.isEmpty || hours.isEmpty {
            Alert.basicAlert(title: "Oops...", message: "Please fill in both fields", vc: self)
        } else {
            let t = Float(tips)!
            let h = Float(hours)!
            let rate = t / h
            performSegue(withIdentifier: "rateSet", sender: rate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HoursVC {
            vc.getRate(rate: sender as! Float)
        }
    }
    

}
