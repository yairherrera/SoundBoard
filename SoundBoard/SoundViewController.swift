//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Aisha Belen Macedo Zeballos on 24/10/22.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
//            detener grabacion
            grabarAudio?.stop()
//            cambiar texto del boton grabar
            grabarButton.setTitle("Grabar", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
        }else{
//            empezar a grabar
            grabarAudio?.record()
//            cambiar el texto del boton grabar a detener
            grabarButton.setTitle("Detener", for: .normal)
            reproducirButton.isEnabled = false
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        }catch {}
    }    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData (contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false
    }
    
    func configurarGrabacion(){
        do{
            //            Creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //            creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //            impresion de ruta donde se guardan los archivos
            print("************************")
            print(audioURL!)
            print("************************")
            
            //            crear opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
//            crear el objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
    }
}
