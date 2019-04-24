//  Created by Students on 06/03/2019.
import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var descSwitch: UISwitch!
    @IBOutlet weak var radSwitch: UISwitch!
    
    var mapViewSecond: MKMapView?
    var localPosition = CLLocationCoordinate2D()
    var removedAnnots = [MKAnnotation]()
    var switchBool: Bool = false
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground(colorTop: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), colorBottom: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        
        radSwitch.isOn =  UserDefaults.standard.bool(forKey: "switchState")
    }
    
    @IBAction func descriptionSwitch(_ sender: UISwitch) {
        
    }
    
    @IBAction func radiusSwitch(_ sender: UISwitch) {
        
        if radSwitch.isOn {
            
            UserDefaults.standard.set(sender.isOn, forKey: "switchState")
            setGradientBackground(colorTop: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), colorBottom: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            
            print("-----=======================================----- \n")
            
            for annotation in mapViewSecond?.annotations as! [MKAnnotation] {
                let localPosCoord = CLLocation(latitude: localPosition.latitude, longitude: localPosition.longitude)
                let annotCoord = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let distanceInMeters = localPosCoord.distance(from: annotCoord)
                if distanceInMeters > 10000 {
                    removedAnnots.append(annotation)
                    //UserDefaults.standard.set(removedAnnots, forKey: "removedAnnotsArray")
                }
                
                print("distance no locale lidz \(String(describing: annotation.title!)) ir: " , distanceInMeters)
                
            }
            //var removedAnnots_UserDefault = UserDefaults.standard.object(forKey: "removedAnnotsArray")
            //mapViewSecond?.removeAnnotations(removedAnnots_UserDefault as! [MKAnnotation])
            mapViewSecond?.removeAnnotations(removedAnnots)
        }else if radSwitch.isOn == false {
            
            UserDefaults.standard.set(sender.isOn, forKey: "switchState")
            if removedAnnots.count == 0 {
                //nadar ņako
            }else{
                //var removedAnnots_UserDefault = UserDefaults.standard.object(forKey: "removedAnnotsArray")
                //mapViewSecond?.addAnnotations(removedAnnots_UserDefault as! [MKAnnotation])
                mapViewSecond?.addAnnotations(removedAnnots)
                print("\n pievienotie \(String(describing: mapViewSecond?.annotations.count)). elementi ")
            }
            
        }
    }
    
    

    
    
}
