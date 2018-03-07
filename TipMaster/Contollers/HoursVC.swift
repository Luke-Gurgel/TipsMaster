//
//  HoursVC.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class HoursVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var context: NSManagedObjectContext!
    var members = [Member]()
    var rate: Float?
    var total: Float = 0
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var membersTB: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) { }
    
    func setup() {
        if rate != nil {
            let r = String(describing: rate!)
            rateLbl.text = "Rate: \(r)"
        }
        let req: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            members = try context.fetch(req)
            DispatchQueue.main.async {
                self.membersTB.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getRate(rate: Float) {
        self.rate = rate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath) as! HourCell
        cell.memberLbl.text = members[indexPath.row].name
        if members[indexPath.row].hours != 0.0 {
            cell.hoursTxt.text = String(members[indexPath.row].hours)
        }
        cell.delegate = self
        return cell
    }
    
    @IBAction func confirmCalc(_ sender: Any) {
        let alert = UIAlertController(title: "Calculate tips?", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yup", style: .default) { (_) in
            self.calculateTips()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func calculateTips() {
        do {
            members.forEach { (member) in
                guard let rate = rate else { return }
                let tips = roundf(member.hours * rate)
                member.tips = tips
                total += tips
                member.setValue(tips, forKey: "tips")
            }
            performSegue(withIdentifier: "calculate", sender: total)
            try context.save()
        } catch {
            Alert.basicAlert(title: "Oops..", message: "Saving failed", vc: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultVC {
            vc.getTotal(total: sender as! Float)
        }
    }

}

extension HoursVC: SetHoursProtocol {
    func setHours(cell: HourCell, hours: Float) {
        if let indexPath = membersTB.indexPath(for: cell) {
            members[indexPath.row].hours = hours
            members[indexPath.row].setValue(hours, forKey: "hours")
        }
    }
}


