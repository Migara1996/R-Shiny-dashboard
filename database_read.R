#install.packages("RSQLite")
library(RSQLite)

db=dbConnect(dbDriver("SQLite"),dbname="G:\\NICST_job\\db")
db
#dbDisconnect(db)

df=dbGetQuery(db,"select * from Admission")
str(df)

df


