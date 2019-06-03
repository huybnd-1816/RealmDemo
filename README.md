# RealmDemo
Create App using Realm Database

**NOTE:** 
- Get url realm database to open in Realm Studio:  **Realm.Configuration.defaultConfiguration.fileURL!**

## **Encryption in Realm:**
#### Step 1: #### 
Create encryption key for Realm database: **getKey()** function 
https://github.com/huybnd-1816/RealmDemo/blob/develop/RealmDemo/RealmDemo/Helper/RealmConfigure.swift

#### Step 2: ####
Set configuration of Realm database: **let config = Realm.Configuration**

#### Step 3: ####
Create Realm database: **let realm = try? Realm(configuration: config)**
