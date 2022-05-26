--Set up TDE on the Primary replica

USE MASTER
GO -- Create a Master Key
CREATE MASTER KEY ENCRYPTION BY Password = 'P@ssw0rd1';
 	 -- Backup the Master Key
	 BACKUP MASTER KEY   TO FILE = 'E:\Encryption_Backups\NCCSQLPOCW2k121_MasterKey'   ENCRYPTION BY Password = 'P@ssword1';

 -- Create Certificate Protected by Master Key
 CREATE Certificate NCCSQLPOCW2k121_Cert   WITH Subject = 'NCCSQLPOCW2k121_Certificate';
  	  -- Backup the Certificate
	  BACKUP Certificate NCCSQLPOCW2k121_Cert  TO FILE = 'E:\Encryption_Backups\NCCSQLPOCW2k121_Certificate'
	  WITH Private KEY (FILE = 'E:\Encryption_Backups\NCCSQLPOCW2k121_PrivateKey', ENCRYPTION BY Password = 'P@ssword1'   ); 


-- Move to the database you wish to enable TDE on
USE TestTDE_WithAlwaysOn
GO 
-- Create a Database Encryption Key
CREATE DATABASE ENCRYPTION KEY   WITH Algorithm = AES_128   ENCRYPTION BY Server Certificate NCCSQLPOCW2k121_Cert;

  -- Enable the Database for Encryption by TDE
ALTER DATABASE TestTDE_WithAlwaysOn   SET ENCRYPTION ON; 


--Set up TDE on the Secondary replicas
--Change Database connection to secondary Replica
USE MASTER
GO -- Create a Master Key
CREATE MASTER KEY ENCRYPTION BY Password = 'P@ssw0rd1';
-- Backup the Master Key
 BACKUP MASTER KEY   TO FILE = '\\NCCSQLPOCW2k121\e$\Encryption_Backups\NCCSQLPOCw2k123_MasterKey'   ENCRYPTION BY Password = 'P@ssword1';
 

-- Create Certificate Protected by Master Key
CREATE Certificate NCCSQLPOCw2k123_Cert   FROM FILE = '\\NCCSQLPOCW2k121\e$\Encryption_Backups\NCCSQLPOCW2k121_Certificate'
   WITH Private KEY (FILE = '\\NCCSQLPOCW2k121\e$\Encryption_Backups\NCCSQLPOCW2k121_PrivateKey', Decryption BY Password = 'P@ssword1'   ); 
