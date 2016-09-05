//
//  ViewController.swift
//  Consulta
//
//  Created by Rodrigo Velazquez on 28/08/16.
//  Copyright © 2016 Rodrigo Velazquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var isbnTextField: UITextField!
    
    @IBOutlet weak var portada: UIImageView!
    
    
    
    func searchBookAsynch(urls: String) {
        
        let url = NSURL(string: urls)
        if url != nil{
            let sesion = NSURLSession.sharedSession()
            let bloque = { (datos:NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                            let text = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                            print(text!)
                
                                if((resp) != nil){
                                    dispatch_async(dispatch_get_main_queue()) {
                                        //self.infoTextView.text = text! as String
                                        
                                        do{
                                            
                                            let isbn = self.isbnTextField.text! as String
                                            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                                            let dic1 = json as! NSDictionary
                                            let isbn2 = "ISBN:\(isbn)"
                                            if((dic1[isbn2]) != nil){
                                                let dic2 = dic1[isbn2] as! NSDictionary
                                                self.tituloLabel.text = dic2["title"] as! NSString as String
                                                let dic3 = dic2["authors"] as! NSArray
                                                for autor in dic3
                                                {
                                                    let dic4 = autor as! NSDictionary
                                                    let str = dic4["name"] as! NSString as String
                                                    if((self.autorLabel.text) != nil){
                                                        self.autorLabel.text = self.autorLabel.text! + "; " + str
                                                    }
                                                    else{
                                                        self.autorLabel.text = str
                                                    }
                                                }
                                        
                                                if((dic2["cover"]) != nil)
                                                {
                                                    let dic5 = dic2["cover"] as! NSDictionary
                                                    let imgURL = dic5["large"] as! NSString as String
                                                    dispatch_async(dispatch_get_main_queue()) {
                                                        if let iURL = NSURL(string: imgURL) {
                                                            if let data = NSData(contentsOfURL: iURL) {
                                                                self.portada.image = UIImage(data: data)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                dispatch_async(dispatch_get_main_queue()) {
                                                    self.displayMyAlertMessage("No encontrado")
                                                }
                                                return
                                            }
                                        }
                                        catch _ {}
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
        if((tituloLabel.text) != nil || (autorLabel.text) != nil){
            tituloLabel.text = nil
            autorLabel.text = nil
            portada.image = nil
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

