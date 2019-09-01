//
//  ViewController.swift
//  Art App
//
//  Created by Sachin Katyal on 6/25/19.
//  Copyright © 2019 Sachin Katyal. All rights reserved.
//

import UIKit
import CoreML
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    @IBOutlet weak var label: UILabel!

    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var picButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    var capturedImage:UIImage!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //CameraHandler.prepareCamera()
        previewView.layer.zPosition = 1
        
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
                previewView.bringSubview(toFront: picButton)
                
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        
    }
    
    func setUpPicButton() {
        picButton.layer.borderWidth = 5
        picButton.layer.borderColor = UIColor.white.cgColor
        picButton.tintColor = UIColor.clear
        picButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        picButton.layer.cornerRadius = 0.5 * picButton.bounds.size.width
        picButton.frame.origin = CGPoint(x: UIScreen.main.bounds.width / 2 - picButton.frame.width/2, y: UIScreen.main.bounds.height - picButton.frame.height - 70)
        picButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        picButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        picButton.layer.shadowOpacity = 0.8
        picButton.layer.shadowRadius = 2
        picButton.layer.masksToBounds = false
        picButton.layer.zPosition = 2
    }
    
    func resetPicButton() {
        picButton.alpha = 1
        picButton.layer.position = CGPoint(x: UIScreen.main.bounds.width / 2 - picButton.frame.width/2, y: UIScreen.main.bounds.height - picButton.frame.height - 70)

    }
    
    func setUpResetButton() {
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.text = "x"
        resetButton.titleLabel?.font = UIFont(name: "Arial", size: 20)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        resetButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        resetButton.frame.origin = CGPoint(x: 0.05 * UIScreen.main.bounds.width, y: 0.05 * UIScreen.main.bounds.height)
        resetButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resetButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        resetButton.layer.shadowOpacity = 0.8
        resetButton.layer.shadowRadius = 2
        resetButton.layer.masksToBounds = false
        resetButton.layer.zPosition = 2
        resetButton.isHidden = true
    }
    
    func setUpUI() {
        setUpPicButton()
        setUpResetButton()
        previewView.pinEdges(to: self.view)
    }
    
    
    
    @IBAction func reset(_ sender: Any) {
        label.text = nil
        picButton.isHidden = false
        resetButton.isHidden = true
        
        self.captureSession.startRunning()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.removeFromSuperview()
        view = nil
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
        
    }
    
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.picButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.1) {
                                    self.picButton.transform = CGAffineTransform.identity
                                }
                })
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            DispatchQueue.main.async {
                self.captureSession.stopRunning()
                //self.label.text = self.predictImage(imageView: self.image2show)
                self.label.font = UIFont(name: "Arial", size: 40)
                self.label.textColor = .white
                self.label.frame = CGRect(x: 50, y: 50, width: 200, height: 50)
                self.label.layer.zPosition = 3
                self.label.layer.position = CGPoint(x: UIScreen.main.bounds.width - self.label.frame.width/2, y: 0.1 * UIScreen.main.bounds.height)
                

            }
        }

        capturedImage = UIImage(data:imageData)


        self.performSegue(withIdentifier: "CameraToImageSegue", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PageViewController
        {
            let vc = segue.destination as? PageViewController
            vc?.image = capturedImage
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    func predictImage(imageView: UIImageView) -> String{
        let imageHandler = ImageHandler(image: ImageHandler.resizeImage(image: imageView.image!, targetSize: CGSize(width: 50, height: 50)))
        return imageHandler.predict()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}

