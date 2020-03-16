//
//  ViewController.swift
//  Todo
//
//  Created by Abid AB on 16/2/20.
//  Copyright © 2020 Abid AB. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    var uid: String = ""
    
    @IBOutlet weak var singInOutlet: UIButton!
    
    @IBOutlet weak var passworD: UITextField!
    @IBOutlet weak var emaiL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        singInOutlet.layer.cornerRadius = 15
        emaiL.text = ""
        passworD.text = ""
        
    }
    
    @IBAction func signUpAct(_ sender: Any) {
        
        if emaiL.text != nil && passworD.text != nil{
            Auth.auth().createUser(withEmail: emaiL.text!, password: passworD.text!) { (result, error) in
                if error != nil{
                    print(error?.localizedDescription as Any)
                 
                }
                else{
                    
                    self.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email" : self.emaiL.text!, "password" : self.passworD.text!])
    self.performSegue(withIdentifier: "loginSegu", sender: self)
                    
                }
            }
        }
        
    }
    
    @IBAction func signInAct(_ sender: Any) {
        
        if emaiL.text != nil && passworD.text != nil{
            Auth.auth().signIn(withEmail: emaiL.text!, password: passworD.text!) { (result, error) in
                if error != nil{
                    print(error?.localizedDescription as Any)
                }
                else {
                    self.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "loginSegu", sender: self)
                }
                
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigation = segue.destination as! UINavigationController
        let todoVc = navigation.topViewController as! TodoViewController
        todoVc.userId = uid
        
    }
    
}
