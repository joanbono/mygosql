package main

import (
	"database/sql"
	"flag"
	"fmt"
	"os"

	"github.com/BurntSushi/toml"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jedib0t/go-pretty/table"
)

type Config struct {
	Database database
}

type database struct {
	Server   string
	Port     string
	Database string
	User     string
	Password string
}

var (
	queryFlag  string
	configFlag string
	conf       Config
	data       string
)

func init() {
	flag.StringVar(&queryFlag, "query", "", "Query to perform")
	flag.StringVar(&configFlag, "config", "./config.toml", "config.toml file")
	flag.Parse()
}

func main() {

	if queryFlag == "" {
		fmt.Println("mygosql USAGE:")
		flag.PrintDefaults()
		os.Exit(1)
	}

	if _, err := toml.DecodeFile(configFlag, &conf); err != nil {
		fmt.Println("Error decoding", configFlag, "file")
		os.Exit(1)
	}

	connString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", conf.Database.User, conf.Database.Password, conf.Database.Server, conf.Database.Port, conf.Database.Database)

	db, err := sql.Open("mysql", connString)
	err = db.Ping()

	if err != nil {
		fmt.Println("Error connecting with", connString)
		os.Exit(1)
	}

	t := table.NewWriter()
	t.SetOutputMirror(os.Stdout)
	t.AppendHeader(table.Row{queryFlag})

	rows, err := db.Query(queryFlag)
	for rows.Next() {
		rows.Scan(&data)
		t.AppendRow([]interface{}{data})
	}
	t.Render()
	defer db.Close()
}
