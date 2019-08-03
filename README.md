![](img/mygosql_banner.svg)

## Installation

```bash
make deps
make install
```

## USAGE

Create a `config.toml` file as follows:

```toml
# filename: config.toml
[database]
user = "root"
password = "toor"
server = "localhost"
port = "3306"
database = "MyDatabase"
```

Then you can use it:

```bash
mygosql USAGE:
  -config string
    	config.toml file (default "./config.toml")
  -query string
    	Query to perform
```

There are not much functions supported yet:

```bash
➜  mygosql -query "SHOW Databases;"
+--------------------+
| SHOW DATABASES;    |
+--------------------+
| MyDatabase         |
| information_schema |
+--------------------+

➜  mygosql -query "SHOW TABLES;"   
+--------------+
| SHOW TABLES; |
+--------------+
| test         |
| user         |
| pass         |
+--------------+

➜  mygosql -query "SELECT * FROM user;"
+---------------------+
| SELECT * FROM user; |
+---------------------+
| root                |
| admin               |
| john                |
| alice               |
+---------------------+
```


## Building

```bash
make all
``` 
