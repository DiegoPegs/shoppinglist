//
//  ViewController.swift
//  ShoppingList
//
//  Created by Eric Brito on 23/03/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfNome: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.showMainScreen(user: user, animated: false)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showMainScreen(user: User?, animated: Bool = true){
        print("Indo para a proxima tela")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ShoppingTableViewController")else{return}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func performUserChange(user: User?){
        guard let user = user else{return}
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = tfNome.text
        changeRequest.commitChanges { (error) in
            if error != nil {
                print(error!)
            }
            self.showMainScreen(user: user, animated: true)
        }
    }

    func removeListener(){
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        removeListener()
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if (error == nil) {
                self.performUserChange(user: result?.user)
            }else{
                print(error!)
            }
        }
    }
    
    @IBAction func signup(_ sender: UIButton) {
        removeListener()
        Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if (error == nil) {
                self.performUserChange(user: result?.user)
            }else{
                print(error!)
            }
        }
    }
    
}

