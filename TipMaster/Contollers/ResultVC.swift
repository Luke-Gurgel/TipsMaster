//
//  ResultVC.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit
import CoreData

class ResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var membersCol: UICollectionView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    var total = ""
    var context: NSManagedObjectContext!
    var members = [Member]()
    
// MARK: SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupData() {
        totalLbl.text = "$\(total)"
        let req: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            let tempArr = try context.fetch(req)
            members = mergeSort(tempArr).reversed()
            DispatchQueue.main.async {
                self.membersCol.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
        countLbl.text = "1 of \(members.count)"
    }
    
    func getTotal(total: Float) {
        self.total = String(total)
    }

// MARK: COLLECTIONVIEW STUBS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tipsCell", for: indexPath) as! TipsCell
        cell.setup(member: members[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in membersCol.visibleCells {
            if let indexPath = membersCol.indexPath(for: cell) {
                let index = String(indexPath.row + 1)
                let count = String(members.count)
                countLbl.text = "\(index) of \(count)"
            }
        }
    }
    
// MARK: RESETING HOURS AND TIPS
    
    @IBAction func done(_ sender: Any) {
        let alert = UIAlertController(title: "Sure you're done?", message: "This will reset everyone's hours and tips", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yup", style: .default) { (_) in
            self.reset()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func reset() {
        members.forEach { (member) in
            member.tips = 0.0
            member.hours = 0.0
            member.setValuesForKeys(["hours": 0.0, "tips": 0.0])
            do {
                try context.save()
            } catch {
                Alert.basicAlert(title: "Oops..", message: "Saving failed", vc: self)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
// MARK: SORTING THE ARRAY BASED ON TIPS
    
    func mergeSort(_ arr: [Member]) -> [Member] {
        guard arr.count > 1 else { return arr }
        let left = Array(arr[0..<arr.count/2])
        let right = Array(arr[arr.count/2..<arr.count])
        return sort(left: mergeSort(left), right: mergeSort(right))
    }
    
    func sort(left: [Member], right: [Member]) -> [Member] {
        var arr = [Member]()
        var left = left
        var right = right
        while left.count > 0 && right.count > 0 {
            if left.first!.tips < right.first!.tips {
                arr.append(left.removeFirst())
            } else {
                arr.append(right.removeFirst())
            }
        }
        return arr + left + right
    }

}










