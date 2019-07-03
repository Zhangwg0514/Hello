//
//  ELDatabase.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit
import CoreData

class ELDatabase: NSObject {
    static var instance = ELDatabase()
    
    func initUser() {
        var username = UserDefaults.standard.string(forKey: "CurrentUsername")
        if username == nil {
            username = kDefaultUsername
            let managedObjectContext = persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
            
            newUser.username = username
            newUser.password = ""
            
            do{
                try managedObjectContext.save()
                print("default user save success.")
            } catch{
                print("Failed to save data.")
            }
            UserDefaults.standard.setValue(username, forKey: "CurrentUsername")
            UserDefaults.standard.synchronize()
        }
        curUserName = username!
    }
    
    func saveAccount(_ account:AccountModel, callback:((Bool, String)->())) {
        let newAcc = NSEntityDescription.insertNewObject(forEntityName: "Account", into: persistentContainer.viewContext) as! Account
        newAcc.accounticon = account.accounticon
        newAcc.username = account.username
        newAcc.accountname = account.accountname
        newAcc.accountpass = account.accountpass
        newAcc.time = account.time
        newAcc.id = account.id
        newAcc.desc = account.desc
        
        do{
            try persistentContainer.viewContext.save()
            callback(true, "Save Account Success!")
        } catch{
            callback(false, "Save Account Failed!")
        }
    }
    
    func getAccountList(callback:@escaping (([AccountModel])->())) {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "username=%@", curUserName)
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [Account]
            var accs = [AccountModel]()
            for  acc in fetchObject {
                let model = AccountModel(acc)
                accs.append(model)
            }
            callback(accs)
        }
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            print("get Accounts error")
        }
    }
    
    func clearCurrentUserAccounts() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "username=%@", curUserName)
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [unowned self] (result : NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [Account]
            for  acc in fetchObject {
                context.delete(acc)
            }
            self.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("UserAccountsDeleted"), object: nil)
        }
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            print("delete Accounts error")
        }
    }
    
    
    
    func getUserList(callback:@escaping (([UserModel])->())) {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [User]
            var users = [UserModel]()
            for  user in fetchObject {
                let model = UserModel(user)
                users.append(model)
            }
            callback(users)
        }
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            print("get Users error")
        }
    }
    
    func saveUser(_ user:UserModel, callback:((Bool, String)->())) {
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: persistentContainer.viewContext) as! User
        
        newUser.username = user.username
        newUser.password = user.password
        newUser.prompts = user.prompts
        newUser.answer = user.answer
        newUser.id = user.id
        
        do{
            try persistentContainer.viewContext.save()
            callback(true, "Save User Success!")
        } catch{
            callback(false, "Save User Failed!")
        }
    }
    
    func editUser(oldUser user:UserModel, newUser nUser:UserModel, callback:((Bool, String)->())) {
        guard let newUser = fetchUserByName(name: user.username) else {
            callback(false, "Edit user name failed")
            return
            
        }
        newUser.username = nUser.username
        newUser.password = nUser.password
        newUser.prompts = nUser.prompts
        newUser.answer = nUser.answer
        newUser.id = nUser.id
        
        do{
            try persistentContainer.viewContext.save()
            callback(true, "Edit User Success!")
        } catch{
            callback(false, "Edit User Failed!")
        }
    }
    
    func deleteUser(_ user:UserModel, callback:((Bool, String)->())) {
        
    }
    
    func fetchUserByName(name:String) -> User? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", name)
        do {
            let results = try context.fetch(fetchRequest) as! [User]
            
            if results.count > 0 {
                return results[0]
            }
        } catch {
            print("fetch user by name error")
        }
        return nil
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



