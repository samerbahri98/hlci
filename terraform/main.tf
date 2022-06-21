module "mysql_db" {
  source        = "./modules/mysql_db"
  endpoint      = var.endpoint
  root_username = var.root_username
  root_password = var.root_password
  dbname        = var.dbname
  db_username   = var.db_username
  db_password   = var.db_password
}
