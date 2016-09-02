//
//  ViewController.swift
//  Consulta
//
//  Created by Rodrigo Velazquez on 28/08/16.
//  Copyright © 2016 Rodrigo Velazquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var isbnTextField: UITextField!
    
    func searchBook(urls: String){
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        let text = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        print(text!)
        infoTextView.text = text! as String
    }
    
    func searchBookAsynch(urls: String) {
        
        let url = NSURL(string: urls)
        if url != nil{
            let sesion = NSURLSession.sharedSession()
            let bloque = { (datos:NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                            let text = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                            print(text!)
                
                                if((resp) != nil){
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.infoTextView.text = text! as String
                                    }
                                }
                                else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                       self.displayMyAlertMessage("Error en la comunicación")
                                    }
                                    return
                                }
                
                          }
            
            let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
            print("antes o despues?")
        }
        else{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.isbnTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        
        sender.resignFirstResponder()
        let isbn = isbnTextField.text!
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        
        searchBookAsynch(urls)
    }
    
    // Ocultar teclado con toque en la pantalla
    @IBAction func backgroundTap(sender: UIControl) {
        
        isbnTextField.resignFirstResponder()
        
        if(isbnTextField.text! != "")
        {
            isbnTextField.text = ""
        }
        
    }
    
    @IBAction func clearTextView(sender: UITextField){
        if((infoTextView.text) != nil){
            infoTextView.text = nil
        }
    }
    
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }


}

