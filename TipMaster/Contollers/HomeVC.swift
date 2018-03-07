//
//  HomeVC.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var membersTB: UITableView!
    @IBOutlet weak var memberTxt: UITextField!
    
    var context: NSManagedObjectContext!
    var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        updateMembers()
        fetchMembers()
//        deleteMembers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) { }
    
    func fetchMembers() {
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        cell.circleView.colorOne = .random()
        cell.circleView.colorTwo = .random()
        cell.memberLbl.text = members[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, index) in
            self.context.delete(self.members[indexPath.row])
            do {
                try self.context.save()
                self.members.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } catch {
                print(error.localizedDescription)
            }
        }
        return [delete]
    }
    
    @IBAction func addMember(_ sender: Any) {
        guard let member = memberTxt.text else { return }
        if !member.isEmpty {
            do {
                let newMember = Member(context: context)
                newMember.name = member
                try self.context.save()
                members.append(newMember)
                reloadTB()
                memberTxt.text = ""
            } catch {
                print(error.localizedDescription)
            }
        } else {
            Alert.basicAlert(title: "Oops...", message: "Please type in the member's name", vc: self)
        }
    }
    
    func reloadTB() {
        DispatchQueue.main.async {
            self.membersTB.reloadData()
            let indexPath = IndexPath(row: self.members.count - 1, section: 0)
            self.membersTB.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // Use it only once 
    
    func updateMembers() {
        DataService.instance.members.forEach { (member) in
            do {
                let user = Member(context: self.context)
                user.name = member.name
                if let hours = member.hours {
                    user.hours = hours
                }
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMembers() {
        let req: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            if let result = try? context.fetch(req) {
                for object in result {
                    context.delete(object)
                }
            }
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }

}
