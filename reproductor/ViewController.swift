//
//  ViewController.swift
//  reproductor
//
//  Created by Carlos on 5/6/16.
//  Copyright © 2016 Personal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var titleAlbum: UILabel!
    @IBOutlet weak var list: UITableView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var shuffButton: UIButton!

    let names = ["Batman","Deadpool","Mission","Pirates","Starwars"]
    let images = ["Bat.jpg","Dead.jpg","Mis.jpg","Pira.jpg","Star.jpg"]
    let cellIdentifier = "CellIdentifier"
    var reproductor : AVAudioPlayer!
    var lastIndex = 0
    var rand = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cover.contentMode = .ScaleAspectFit
        cover.clipsToBounds = true
        slider.value=0.5
    }
    
    @IBAction func play() {
        if reproductor != nil
        {
            if !reproductor.playing
            {
                reproductor.play()
            }
        }
    }
    
    @IBAction func pause() {
        if reproductor != nil
        {
            if reproductor.playing
            {
                reproductor.pause()
            }
        }
    }
    
    @IBAction func stop() {
        if reproductor != nil
        {
            if reproductor.playing
            {
                reproductor.stop()
                reproductor.currentTime=0
            }
        }
    }
    
    @IBAction func random() {
        if rand == false
        {
            shuffButton.selected = true
            rand = true
        }
        else
        {
            shuffButton.selected = false
            rand = false
        }
    }
    
    @IBAction func changeVol() {
        reproductor.volume = slider.value
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetch Fruit
        let song = names[indexPath.row]
        
        // Configure Cell
        cell.textLabel?.text = song
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let song = names[indexPath.row]
        titleAlbum.text = song
        let imageName = images[indexPath.row]
        lastIndex = indexPath.row
        let image = UIImage(named: imageName)
        cover.image = image
        let urlSong = NSBundle.mainBundle().URLForResource(song, withExtension: "mp3")

        do{
            try reproductor = AVAudioPlayer(contentsOfURL: urlSong!)
        }
        catch
        {
            print("Fail")
        }
        reproductor.volume=0.5
        reproductor.delegate = self
        reproductor.prepareToPlay()
        reproductor.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        if rand == false
        {
            lastIndex += 1
            if lastIndex<=names.count-1
            {
                let indexPath = NSIndexPath(forRow: lastIndex, inSection: 0);
                list.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                let song = names[lastIndex]
                titleAlbum.text = song
                let imageName = images[lastIndex]
                let image = UIImage(named: imageName)
                cover.image = image
                let urlSong = NSBundle.mainBundle().URLForResource(song, withExtension: "mp3")
                
                do{
                    try reproductor = AVAudioPlayer(contentsOfURL: urlSong!)
                }
                catch
                {
                    print("Fail")
                }
                reproductor.delegate = self
                reproductor.prepareToPlay()
                reproductor.play()
            }
        }
        else
        {
            var randomNumber = Int(arc4random_uniform(5))
            while randomNumber == lastIndex {
                randomNumber = Int(arc4random_uniform(5))
            }
            if randomNumber != lastIndex
            {
                let indexPath = NSIndexPath(forRow: randomNumber, inSection: 0);
                list.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                lastIndex = randomNumber
                let song = names[randomNumber]
                titleAlbum.text = song
                let imageName = images[randomNumber]
                let image = UIImage(named: imageName)
                cover.image = image
                let urlSong = NSBundle.mainBundle().URLForResource(song, withExtension: "mp3")
                
                do{
                    try reproductor = AVAudioPlayer(contentsOfURL: urlSong!)
                }
                catch
                {
                    print("Fail")
                }
                reproductor.delegate = self
                reproductor.prepareToPlay()
                reproductor.play()
            }
        }
    }
}

