//
//  TodoViewController.swift
//  Todo
//
//  Created by Abid AB on 20/2/20.
//  Copyright © 2020 Abid AB. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct todo {
    var check: Bool
    var todoName: String
}

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cusTableViewController: UITableView!
    
    var userId:String?
    var todos: [todo] = []
     
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWelcomeLbl()
        
        cusTableViewController.delegate = self
        cusTableViewController.dataSource = self
    
        loadTodo()
      
    }
    
    func setWelcomeLbl(){
        
        let userRef = Database.database().reference(withPath: "users").child(userId!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value!["email"] as? String
            self.titleLbl.text = email
        }
        
    }
    
    //Logout
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        do{
        try Auth.auth().signOut()
            let fV = ViewController()
       let welNev  = UINavigationController (rootViewController: fV)
            self.present(welNev, animated: true, completion: nil)
            print("yo")
            self.dismiss(animated: true, completion: nil)
        }
        catch let err {
            print (err.localizedDescription)
        }
            
    }
    
    
    
    
    //add Todo
    @IBAction func addTodo(_ sender: Any) {
        
        let todoAlert = UIAlertController(title: "New Todo", message: "Add a Todo", preferredStyle: .alert)
        
        todoAlert.addTextField()
        
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { (action) in

            let todoText = todoAlert.textFields![0].text
            self.todos.append(todo(check: false, todoName: todoText!))
            let ref = Database.database().reference(withPath: "users").child(self.userId!).child("todos")
            ref.child(todoText!).setValue(["checking" : false])
            
            self.cusTableViewController.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        todoAlert.addAction(addTodoAction)
        todoAlert.addAction(cancelAction)
        
        present (todoAlert, animated: true, completion: nil)
        
    }
    
    
    
    
    //Load data from database
    func loadTodo () {
        
        let ref = Database.database().reference(withPath: "users").child(userId!).child("todos")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let todoName = child.key
                let todoRef = ref.child(todoName)
                todoRef.observeSingleEvent(of: .value) { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    let check = value! ["checking"] as? Bool
                    self.todos.append(todo(check: check!, todoName: todoName))
                    self.cusTableViewController.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tdcell = cusTableViewController.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! todoTableViewCell
        
        tdcell.todoLbl.text = todos[indexPath.row].todoName
        if todos[indexPath.row].check
        {
            tdcell.checkImg.image = #imageLiteral(resourceName: "6705921_preview")

        }
        else
        {
            tdcell.checkImg.image = nil
        }
        
        
        
        return tdcell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = Database.database().reference(withPath: "users").child(userId!).child(todos[indexPath.row].todoName)
        if todos[indexPath.row].check{
            todos[indexPath.row].check = false
            ref.updateChildValues(["checking": false])
        }
        else{
            todos[indexPath.row].check = true
            ref.updateChildValues(["checking": true])
        }
        
        cusTableViewController.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference(withPath: "users").child(userId!).child("todos").child(todos[indexPath.row].todoName)
            ref.removeValue()
            todos.remove(at: indexPath.row)
            cusTableViewController.reloadData()
        }
    }
    

}
