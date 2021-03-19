//
//  CameraViewController.swift
//  Parstagram
//
//  Created by MD Islam on 3/15/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        commentField.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
         let post = PFObject(className: "Post")
         post["caption"] = commentField.text!
         post["author"] = PFUser.current()
         
         let imageData = imageView.image!.pngData()
         let file = PFFileObject(name: "image.png", data: imageData!)
         
         post["image"] = file
         
         post.saveInBackground{(success, error) in
             if success{
                 self.dismiss(animated: true, completion: nil)
                 print("Saved!")
             }else{
                 print("error!: \(String(describing: error))")
             }
         }
         
     }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        picker.sourceType = .photoLibrary
    } else {
        picker.sourceType = .camera
        
    }
        
        present(picker, animated:  true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
                
                let size = CGSize(width: 300, height: 300)
                let scaledImage = image.af_imageAspectScaled(toFill: size)
                
                imageView.image = scaledImage
                
                dismiss(animated: true, completion: nil)
            }
    func hideKeyboard() {
        commentField.resignFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
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
