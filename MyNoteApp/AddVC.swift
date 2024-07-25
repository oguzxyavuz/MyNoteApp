//
//  addVC.swift
//  MyNoteApp
//
//  Created by Oğuzhan Yavuz on 24.07.2024.
//

import UIKit
import CoreData

class AddVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textArray: UITextView!
    @IBOutlet weak var titleArray: UITextField!
    
    var chosenTitle = ""
    var chosenId : UUID?
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArray.delegate = self
        
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Add Note..."
        placeholderLabel.font = .italicSystemFont(ofSize: (textArray.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textArray.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textArray.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textArray.text.isEmpty

        

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        if chosenTitle != "" {
            
            saveButton.isHidden = true
            placeholderLabel.isHidden = true
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            let idString = chosenId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            titleArray.text = title
                        }
                        if let text = result.value(forKey: "text") as? String {
                            textArray.text = text
                        }
                    }
                    
                }
                
            } catch {
                print("error")
            }
            
        } else {
            titleArray.text = ""
            textArray.text = ""
            saveButton.isHidden = false
            placeholderLabel.isHidden = false
        }
        
        
        
        
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = AppDelegate.persistentContainer.viewContext

        let newNote = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        
        newNote.setValue(titleArray.text!, forKey: "title")
        newNote.setValue(textArray.text!, forKey: "text")
        newNote.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
            placeholderLabel.isHidden = true
        
    }

    
}

