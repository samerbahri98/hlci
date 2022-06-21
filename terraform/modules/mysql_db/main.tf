terraform {
  required_providers {
    mysql = {
      source  = "winebarrel/mysql"
      version = "1.10.6"
    }
  }
}

provider "mysql" {
  endpoint = var.endpoint
  username = var.root_username
  password = var.root_password
}
resource "mysql_database" "service_db" {
  name = var.dbname
  lifecycle {
    create_before_destroy = false
  }
}
resource "mysql_user" "service_user" {
  user               = var.db_username
  host               = "%"
  plaintext_password = var.db_password
}

resource "mysql_grant" "service_grant" {
  user       = mysql_user.service_user.user
  database   = mysql_database.service_db.name
  host       = mysql_user.service_user.host
  privileges = ["ALL"]
}
