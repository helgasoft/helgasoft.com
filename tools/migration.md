<div markdown=1>
## Migrating from Sql Server to PostgreSQL


After many years of Sql Server as primary database platform, it was time for something new and fresh. Looking at alternatives with comparable features and performance (but less costly), our preference went to PostgreSQL, mostly for its [merge](https://www.postgresql.org/docs/current/static/sql-insert.html) capabilities.  
PostgreSQL is free, open-source and can be hosted on Linux or Windows. For Windows, the official site offers [two download options](https://www.postgresql.org/download/windows/) from which we chose [EnterpriseDB](http://www.enterprisedb.com/products/pgdownload.do#windows).  The installation passed without problems.

Below is my experience with the [**EDB Migration Toolkit**](https://www.enterprisedb.com/products/edb-postgres-platform/edb-migration-toolkit) . 
You can 
read the [documentation](https://www.enterprisedb.com/resources/edb-product-documentation/edb-postgres-migration-toolkit-guide-96) online or [in PDF](https://get.enterprisedb.com/docs/EDB_Postgres_Migration_Guide_v50.0.3.pdf).  
I used it to move some large SQL Server tables to PostgreSQL.

The migration software installed thru StackBuilder, a tool included in the PostgreSql installation and accessible thru PgAdmin > Tools (see 4.3 in the documentation above).

First thing to do was to customize the configuration file C:\Program Files (x86)\edb\mtk\etc\ **toolkit.properties**. My settings:
```javascript
	SRC_DB_URL=jdbc:jtds:sqlserver://127.0.0.1:1433/myDBname
	SRC_DB_USER=user1
	SRC_DB_PASSWORD=xxxx
	
	TARGET_DB_URL=jdbc:postgresql://localhost:5432/postgres
	TARGET_DB_USER=postgres
	TARGET_DB_PASSWORD=zzzz
```
Then, to start the migration, I ran the following two commands in a Command Prompt window:
```javascript
cd "C:\Program Files (x86)\edb\mtk\bin"  
runMTK.bat -sourcedbtype sqlserver -targetdbtype postgres mySSschema
```
And got the following error:

_MTK-11009: Error Connecting Database "SQL Server"_  
_java.lang.ClassNotFoundException: net.sourceforge.jtds.jdbc.Driver_

The Sql Server driver was missing.  So I got it following these two links
https://www.enterprisedb.com/advanced-downloads
https://sourceforge.net/projects/jtds/files/latest/download?source=files  
Then unzipped file __jtds-1.3.1-dist.zip__ in folder C:\Program Files (x86)\edb\mtk\lib	

Trying again got me another error:

_Connecting with target Postgres database server...  
Exception in thread "main" java.lang.NoClassDefFoundError: org/postgresql/Driver  
 com.edb.dbhandler.postgresql.PGConnection.< init>(PGConnection.java:32_

Turned out the PostgreSql driver was missing too!  Naively I thought that at least this one was included...  
Searched and [found it here](https://jdbc.postgresql.org/download.html). Link "PostgreSQL JDBC 4.2 Driver" downloaded file __postgresql-42.1.1.jar__.
I moved it to folder C:\Program Files (x86)\edb\mtk\lib, the same where the Sql Server driver was.

Then I realized the page instruction "_If you are using Java 8 or newer then you should use the JDBC 4.2 version._"  
Well, I had already the latest 4.2 driver, but did I have the latest Java environment ?
Decided to go ahead and [update Java](https://www.java.com/en/download/) to the current version.

After that runMTK did not even start, coming back with error _"Unable to find JRE in path."_  
Apparently runMTK.bat was referencing another config file C:\Program Files (x86)\edb\mtk\etc\sysconfig\ **edbmtk-50.config**
which had this line:
```javascript
JAVA_EXECUTABLE_PATH="C:\Program Files (x86)\Java\jre1.8.0_111\bin\java.exe"
```
I updated it to the path to the newly installed JRE:
```javascript
JAVA_EXECUTABLE_PATH="C:\Program Files (x86)\Java\jre1.8.0_131\bin\java.exe"
``` 
&nbsp;

Finally everything fell into place and the batch migration proceeded as expected.
```javascript
	>runMTK.bat -sourcedbtype sqlserver -targetdbtype postgres mySSschema
	Connecting with source SQL Server database server...
	Connected to Microsoft SQL Server, version '10.50.4042'
	Connecting with target Postgres database server...
	Connected to PostgreSQL, version '9.6.3'
	Importing sql server schema mySSschema...
	Creating Schema...mySSschema
	Creating Tables...
	... Table Data Load Summary: Total Time(s): 786 Total Rows: 19078096 Total Size(MB): 1155 ...
	Schema mySSschema imported successfully.
	Migration process completed successfully.
```
Phew! Just another rollercoaster.

&nbsp;

#### Additional Resources:

* https://www.devbridge.com/articles/migrating-from-mssql-to-postgresql/#
* https://www.packtpub.com/books/content/migrating-ms-sql-server-2008-enterprisedb
* https://github.com/dalibo/sqlserver2pgsql

&nbsp;

&nbsp;

</div>