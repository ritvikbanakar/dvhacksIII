//
//  DrunkVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit



class DrunkVC: UIViewController {
    
    let defaults = UserDefaults.standard //Gets user defaults to get the friend phone number

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //Calls friend contact when pressed
    @IBAction func callContact(_ sender: Any) {
        var number = defaults.string(forKey: defaultsKeys.friend1_phone)
        number = "tel://" + number!
        var url = URL(string: number!)
        UIApplication.shared.openURL(url!)
    }
    
    //Goes back to testing home page when pressed
    @IBAction func repeatTest(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
