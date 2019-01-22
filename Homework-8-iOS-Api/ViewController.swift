//
//  ViewController.swift
//  Homework-8-iOS-Api
//
//  Created by Alla on 1/16/19.
//  Copyright © 2019 AndreiSavchenko. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    var idForGet: String = ""
    var urlForDownloadMp4: String = ""
    var urlCompGif: URL?
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    @IBOutlet weak var idForGetFromPost: UILabel!
    @IBOutlet weak var urlForDownload: UILabel!
    @IBOutlet weak var procLabel: UILabel!
    @IBOutlet weak var procProgressView: UIProgressView!
    
    
    @IBAction func postButton(_ sender: UIButton) {
        let urlPostString = "https://upload.giphy.com/v1/gifs?api_key=lc3aGasGwDbt4ZWhRNQGWsZIbS4dzuBu&source_image_url=https://media.giphy.com/media/4JYoobSAZZ2mY/giphy.gif"
        
        guard let urlPost = URL(string: urlPostString) else { return }
        
        var request = URLRequest(url: urlPost)
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("RESPONSE \(response)")
            }
            guard let data = data else { return }
            do {
                let modelPost = try JSONDecoder().decode(ModelPost.self, from: data)
                self.idForGet = modelPost.data.id
                print("DATA \(modelPost)")
                DispatchQueue.main.async {
                    self.idForGetFromPost.text = self.idForGet
                }
            } catch {
                print("ERROR \(error)")
            }
        }.resume()
    }
    
    @IBAction func getButton(_ sender: UIButton) {
        
        let urlGetBase = "https://api.giphy.com/v1/gifs/"+idForGet
        guard var urlGetBaseComponents = URLComponents(string: urlGetBase) else { return }
        
        if idForGet != "" {
            urlGetBaseComponents.queryItems = [.init(name: "api_key", value: "lc3aGasGwDbt4ZWhRNQGWsZIbS4dzuBu")]
        } else {
            print("Error not found ID")
            return
        }
        
        session.dataTask(with: urlGetBaseComponents.url!) { (data, response, error) in
            if let response = response {
                print("RESPONSE \(response)")
            }
            guard let data = data else { return }
            do {
                let modelGet = try JSONDecoder().decode(ModelGet.self, from: data)
                self.urlForDownloadMp4 = modelGet.data.images.original_mp4.mp4
                print("DATA \(modelGet)")
                DispatchQueue.main.async {
                    self.urlForDownload.text = self.urlForDownloadMp4
                }
            } catch {
                print("ERROR \(error)")
            }
        }.resume()
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @IBAction func downloadButton(_ sender: UIButton) {
        print("Download started file")
        shapeLayer.strokeEnd = 0
        guard let url = URL(string: urlForDownloadMp4) else { return }
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
//        animateCircle()
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        print(percentage)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
            self.procProgressView.progress = Float(percentage)
            self.procLabel.text = String(Int(percentage*100))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //        try? FileManager.default.removeItem(at: location)
        print("Download finished file \(location)")
        
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            urlCompGif = destinationURL
            guard let url = urlCompGif else { return }
            print("urlCompGif \(url)")
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func openButton(_ sender: UIButton) {
        guard let url = urlCompGif else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
//-------------------------------------
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        let trackLayer = CAShapeLayer()
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(shapeLayer)
    }
}
