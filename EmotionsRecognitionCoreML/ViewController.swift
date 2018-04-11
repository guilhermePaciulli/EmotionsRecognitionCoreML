//
//  ViewController.swift
//  EmotionsRecognitionCoreML
//
//  Created by Guilherme Paciulli on 09/04/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    //IBOutlet
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    
    //Instance Variables
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var captureOptions: AVCapturePhotoSettings?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setting up the camera
        session = AVCaptureSession()
        session!.sessionPreset = .photo
        
        guard let frontCamera: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
            fatalError("Impossible to get the front camera")
        }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: frontCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            stillImageOutput = AVCapturePhotoOutput()
            captureOptions = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            
        }
        
        if session!.canAddOutput(stillImageOutput!) {
            session!.addOutput(stillImageOutput!)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewView.layer.addSublayer(videoPreviewLayer!)
            session!.startRunning()
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoPreviewLayer!.frame = previewView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Aux Funcs
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        if stillImageOutput!.connection(with: AVMediaType.video) != nil {
            stillImageOutput?.capturePhoto(with: captureOptions!, delegate: self)
        }
    }
    
    //MARK: AVCapturePhotoCaptureDelegate
    
    
}

