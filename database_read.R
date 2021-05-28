#install.packages("RSQLite")
library(RSQLite)

db=dbConnect(dbDriver("SQLite"),dbname="G:\\NICST_job\\db")
db
#dbDisconnect(db)

#df1=dbGetQuery(db,"select * from Admission_wide")
#df3=dbGetQuery(db,"select * from AdmissionAssessment_wide")
df2=dbGetQuery(db,"select * from CoreForms_wide")

str(df2)
#df2$mechanically_ventilated
sum(is.na(df2$AdmissionAssessment.antibiotics))

names(df2)[names(df2) == "AdmissionAssessment.antibiotics"] <- "antibiotics"
names(df2)[names(df2) == "AdmissionAssessment.cardiovascular_support"] <- "cardiovascular_support"
names(df2)[names(df2) == "AdmissionAssessment.mechanically_ventilated"] <- "mechanically_ventilated"
names(df2)[names(df2) == "Admission.admission_type"] <- "admission_type"

#df2$date_of_admission[df2$mechanically_ventilated=="mechanical_vent"]
mech=table(df2$date_of_admission[df2$mechanically_ventilated=="mechanical_vent"])

df4=data.frame(mech)

#write.table(df2,file = "core_data.csv",sep = ",")
df4$Var1<- as.Date(df4$Var1)


library(ggplot2)

ggplot(data = d, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "deepskyblue1") +
  labs(title = "Mechanically ventilated within 24 hours of admission",
       x = "Date", y = "Number of Pateints")


a=read.csv("new_file.csv")
b=read.csv("mech.csv")
#a=read.csv("freq.csv")
#a$Var1=as.Date(a$Var1, '%m/%d/%Y')
a$Var1=as.Date(a$Var1, '%m/%d/%Y')
b$Var1=as.Date(b$Var1, '%m/%d/%Y')


freq1=numeric(1257)
for (i in 1:length(a$Var1)) {
  for (j in 1:length(b$Var1)) {
    if(as.Date(a$Var1[i])==as.Date(b$Var1[j])){
      freq1[i]=b$Freq[j]
    }
  }
  
}
freq1
a$Freq_mech=freq1
a$No=df7$No
a$Yes=df7$Yes
#write.table(a,file = "an_mech_ad.csv",sep = ",")


# admission and antibiotics for pie chart
str(as.factor(df2$antibiotics))
df5=data.frame(df2$date_of_admission,df2$antibiotics)
str(df5)
names(df5)[names(df5) == "df2.antibiotics"] <- "antibiotics"
names(df5)[names(df5) == "df2.date_of_admission"] <- "date_of_admission"


df5$antibiotics[is.na(df5$antibiotics)]="No"
df5=na.omit(df5)
df5$antibiotics=as.factor(df5$antibiotics)

df6=data.frame(table(df5))

# df6$date_of_admission[2514]="2018-05-14"
# df6$date_of_admission[1256]="2018-05-14"
# 
# df6$date_of_admission[1]="2009-05-18"
# df6$date_of_admission[1257]="2009-05-18"

df7=data.frame(df6$date_of_admission[1:1257],df6$Freq[1:1257])
df7$Yes=df6$Freq[1258:2514]

names(df7)[names(df7) == "df6.Freq.1.1257."] <- "No"
names(df7)[names(df7) == "df6.date_of_admission.1.1257."] <- "date_of_admission"

df7$date_of_admission=as.Date(df7$date_of_admission)
df7$date_of_admission

df7$date_of_admission[1]="2009-05-18"
df7$date_of_admission[1257]="2018-05-14"



c=df7[df7$date_of_admission>=as.Date('2020-05-15') & df7$date_of_admission<=as.Date('2020-05-20'),]
c

count=c(sum(c$Yes),sum(c$No))
group=c("Yes","No")
d=data.frame(count,group)
d

# Basic piechart
per=round(c((sum(c$Yes)*100)/(sum(c$Yes)+sum(c$No)),(sum(c$No)*100)/(sum(c$Yes)+sum(c$No))))
ypos=cumsum(per)-0.5*per
#ypos=100-ypos


ggplot() +
  geom_bar(aes(x="", y=per, fill=group),stat="identity", width=1, color="white") +
  labs(title = "Antibiotics within 24 hours of admission") +
  coord_polar("y", start=0) +
  
  #scale_fill_manual(values=c("skyblue", "midnightblue"))+
  geom_text(aes(x="",y=ypos,
    label =paste0(per,"%")), 
    size=5)+
  #scale_colour_manual(values=c("white", "white"))+
  theme_void() # remove background, grid, numeric labels

# df2$mechanically_ventilated[df2$mechanically_ventilated!="mechanical_vent"]=0
# df2$mechanically_ventilated[is.na(df2$mechanically_ventilated)]=0
# df2$mechanically_ventilated[df2$mechanically_ventilated=="mechanical_vent"]=1
# 
# 
#   
# as.integer(df2$mechanically_ventilated)
# 
# 
# k=data.frame(as.Date(df2$date_of_admission),as.integer(df2$mechanically_ventilated))
# k=na.omit(k)
# k
# p=data.frame(table(k))
# p
# dim(p)

# cardiovascular support

df8=data.frame(df2$date_of_admission,df2$cardiovascular_support)
str(df8)
names(df8)[names(df8) == "df2.cardiovascular_support"] <- "cardiovascular_support"
names(df8)[names(df8) == "df2.date_of_admission"] <- "date_of_admission"


df8$cardiovascular_support[is.na(df8$cardiovascular_support)]="No"
df8=na.omit(df8)
df8$cardiovascular_support=as.factor(df8$cardiovascular_support)

df9=data.frame(table(df8))
df10=data.frame(df9$date_of_admission[1:1257],df9$Freq[1:1257])
df10$Yes=df9$Freq[1258:2514]

names(df10)[names(df10) == "df9.Freq.1.1257."] <- "No"
names(df10)[names(df10) == "df9.date_of_admission.1.1257."] <- "date_of_admission"

df10$date_of_admission=as.Date(df10$date_of_admission)
df10$date_of_admission

df10$date_of_admission[1]="2009-05-18"
df10$date_of_admission[1257]="2018-05-14"

a$No_card=df10$No
a$Yes_card=df10$Yes


# Admission type
plan=table(df2$date_of_admission[df2$admission_type=="Planned"])
unplan=table(df2$date_of_admission[df2$admission_type=="Unplanned"])

df11=data.frame(plan) #planned
df11$Var1<- as.Date(df11$Var1)
df12=data.frame(unplan) #unplanned
df12$Var1<- as.Date(df12$Var1)

df12$Var1[df12$Var1=="0009-05-18"]="2009-05-18"
df12$Var1[df12$Var1=="2118-05-14"]="2018-05-14"

#  This is for planned
freq2=numeric(1257)
for (i in 1:length(a$Var1)) {
  for (j in 1:length(df11$Var1)) {
    if(as.Date(a$Var1[i])==as.Date(df11$Var1[j])){
      freq2[i]=df11$Freq[j]
    }
  }
  
}
a$planned=freq2

#  This is for unplanned
freq3=numeric(1257)
for (i in 1:length(a$Var1)) {
  for (j in 1:length(df12$Var1)) {
    if(as.Date(a$Var1[i])==as.Date(df12$Var1[j])){
      freq3[i]=df12$Freq[j]
    }
  }
  
}
a$unplanned=freq3

data.frame(df2$date_of_admission,df2$Discharge.date_of_discharge)

date_strings = c(df2$date_of_admission,df2$Discharge.date_of_discharge)
datetimes = strptime(na.omit(date_strings), format = "%Y-%m-%d")
datetimes
diff_in_days = difftime(datetimes[2], datetimes[1], units = "days") # days
diff_in_days

max(sort(df13$date_of_admission))

df13=df2[df2$unitId=="5d7a22aa717864001b82ba32",]
sum(is.na(df13$date_of_admission))

table(df13$date_of_admission)
df13$Admission.diagnosis_type
df13$admission_type


df13$AdmissionAssessment.apache_score

#apache score calculation

df13$date_of_admission<- as.Date(df13$date_of_admission)
df13$AdmissionAssessment.apache_score=as.integer(df13$AdmissionAssessment.apache_score)
c=df13[df13$date_of_admission>=as.Date('2020-05-01') & df13$date_of_admission<=as.Date('2020-05-31'),]
c$AdmissionAssessment.apache_score=as.integer(c$AdmissionAssessment.apache_score)
c$AdmissionAssessment.apache_score

if(length(c$AdmissionAssessment.apache_score)>sum(is.na(c$AdmissionAssessment.apache_score))){
  cat("mean apache score:",mean(c$AdmissionAssessment.apache_score,na.rm = TRUE))
}else{
  cat("No Data")
}



dates=data.frame(table(df13$date_of_admission))

k=seq(as.Date("2017/11/1"),as.Date("2021/01/31"),by="day")
newdf=data.frame(k)
names(newdf)[names(newdf) == "k"] <- "Var1"


f1=numeric(1188)
for (i in 1:length(newdf$Var1)) {
  for (j in 1:length(dates$Var1)) {
    if(as.Date(newdf$Var1[i])==as.Date(dates$Var1[j])){
      f1[i]=dates$Freq[j]
    }
  }
  
}
f1
newdf$Freq=f1


c=newdf[newdf$Var1>=as.Date('2020-05-01') & newdf$Var1<=as.Date('2020-05-20'),]
c

yaxis <- list(
  title = 'Number of patients',
  automargin = TRUE
)

fig<-plot_ly(c,x =c$Var1, y =c$Freq, 
             width = 400, height = 300, type = 'bar',color = I("deepskyblue1"))
fig<- fig %>% layout(autosize = F,title="ICU admissions",yaxis=yaxis)

fig


