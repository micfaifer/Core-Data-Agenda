//
//  MainTableViewController.swift
//  DesafioTabelas
//
//  Created by Lourenço Biselli on 10/04/17.
//  Copyright © 2017 Lourenço Biselli. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var contatos = [Contato]()
    
    //    var categorias: [String] = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        loadContatos()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    func loadContatos() {
        let personFetch = NSFetchRequest<Contato>(entityName: "Contato")
        do {
            contatos = try DBManager.shared.context.fetch(personFetch)
        }catch{
            print("Erro ao consultar os dados")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let contato = contatos[indexPath.row]
            contatos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DBManager.shared.context.delete(contato)
            
            do{
                try contato.managedObjectContext?.save()
            }catch{
                print("Deu erro ao tentar remover um contato")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //        return categorias.count
        return 1
    }
    
    func filtrando() -> Bool{
        return (searchController.searchBar.text?.isEmpty ?? true) && searchController.isActive
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtrando(){
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contato")
            
            let predicate = NSPredicate(format: "nome like %@", searchController.searchBar.text!)
            fetchRequest.predicate = predicate
         
            do{
                contatos =  try DBManager.shared.context.fetch(fetchRequest) as! [Contato]
            }catch{
                print("deu algum problema ao tentar ler os contatos do banco com essa pesquisa realizada")
            }
        }
        
        return contatos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCell", for: indexPath)
        
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cell.imageView?.layer.cornerRadius = 10.0
        
        cell.textLabel?.text = contatos[indexPath.row].nome
        cell.imageView?.image = contatos[indexPath.row].getImageAsMedia()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @IBAction func salvarToMainViewController(segue: UIStoryboardSegue){
        let salvarTableViewController = segue.source as! SalvarTableViewController
        
        if(salvarTableViewController.isNew == false){
            let index = salvarTableViewController.index
        } else {
        }
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "edit"){
            
            let path = tableView.indexPathForSelectedRow
            let salvarTableViewController = segue.destination as! SalvarTableViewController
            
            if let row = path?.row{
                salvarTableViewController.contato = contatos[(row)]
            }
            
            //let cell = tableView.cellForRow(at: path!)?.textLabel?.text
            
        } else if(segue.identifier == "add"){
            
            let adicionarTableViewController = segue.destination as! SalvarTableViewController
            
            
        }
    }
    
    //MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        loadContatos()
        tableView.reloadData()
    }
}

