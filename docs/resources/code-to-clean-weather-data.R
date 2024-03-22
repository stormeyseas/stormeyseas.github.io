# FETCH AND CLEAN UP AUSTALIAN WEATHER DATA
# Code by Tormey Reimer, 22/2/2024
# Modified and updated using code from "Big Data Sets you can use with R" (https://blog.revolutionanalytics.com/2013/08/big-data-sets-for-r.html) by
# JB Rickert published 22/8/2013 and based on code published by Graham Williams in Data Mining with Rattle and R Appendix B, Springer 2011

library(lubridate)
library(tidyverse)
library(httr)

bomURL = "http://www.bom.gov.au/climate/dwo/"
Melbourne = "/text/IDCJDW3033."
year = 2023
month = sprintf('%02d', 1:12)

headers = c(`user-agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.61 Safari/537.36')

date = paste(year, month[1], sep = "")
url = paste(bomURL, date, Melbourne, date,".csv",sep = "")

res = httr::GET(url = url, httr::add_headers(.headers = headers))
bin = content(res, "raw")
writeBin(bin, "01_data.csv")

# Read as csv
dat = read.csv("01_data.csv", header = F, dec = ",", skip = 5, encoding = "latin1", check.names = TRUE)
heads = unlist(dat[1,])
heads = unname(heads)
heads = gsub(pattern = " ", replacement = "_", heads)
colnames(dat) = heads
weatherDF = dat[2:nrow(dat), 2:ncol(dat)]

# Read in Melbourne weather data 
for(i in 2:12){
	date = paste(year, month[i], sep = "")
	url = paste(bomURL, date, Melbourne, date,".csv",sep = "")
	
	res = httr::GET(url = url, httr::add_headers(.headers = headers))
	bin = content(res, "raw")
	filename = paste(month[i],"data.csv", sep="_")
	writeBin(bin, filename)
	
	# Read as csv
	dat = read.csv(filename, header = F, dec = ",", skip = 5, encoding = "latin1", check.names = TRUE)
	heads = unlist(dat[1,])
	heads = unname(heads)
	heads = gsub(pattern = " ", replacement = "_", heads)
	colnames(dat) = heads
	dat = dat[2:nrow(dat), 2:ncol(dat)]
	
	weatherDF = rbind(weatherDF, dat)
}

colnames(weatherDF) = c("Date", "MinTemp.C", "MaxTemp.C", "Rainfall.mm", "Evaporation.mm", "SunHrs", 
                        "MaxWindGustDir", "MaxWindGustSpeed.kmh", "MaxWindGustTime",
                        "Temp9am.C", "Humidity9am.perc", "Cloud9am.oktas", "WindDir9am", "WindSpeed9am.kmh", "Pressure9am.hPa",
                        "Temp3pm.C", "Humidity3pm.perc", "Cloud3pm.oktas", "WindDir3pm", "WindSpeed3pm.kmh", "Pressure3pm.hPa")

weather.clean = weatherDF

weather.clean$WindSpeed9am.kmh[weather.clean$WindSpeed9am.kmh == "Calm"] = 0
weather.clean$WindDir9am[weather.clean$WindSpeed9am.kmh == 0] = NA
weather.clean$WindSpeed3pm.kmh[weather.clean$WindSpeed3pm.kmh == "Calm"] = 0
weather.clean$WindDir3pm[weather.clean$WindSpeed3pm.kmh == 0] = NA
weather.clean[weather.clean == ""] = NA

weather.clean = weather.clean %>% 
    mutate(Date = as.Date(Date),
           Year = year(Date),
           Month = month(Date),
           Day = day(Date),
           MinTemp.C = as.numeric(MinTemp.C),
           MaxTemp.C = as.numeric(MaxTemp.C),
           Rainfall.mm = as.numeric(Rainfall.mm),
           Evaporation.mm = as.numeric(Evaporation.mm),
           SunHrs = as.numeric(SunHrs),
           MaxWindGustDir = as.factor(MaxWindGustDir),
           MaxWindGustSpeed.kmh = as.numeric(MaxWindGustSpeed.kmh),
           MaxWindGustTime = hm(MaxWindGustTime),
           Temp9am.C = as.numeric(Temp9am.C),
           Humidity9am.perc = as.numeric(Humidity9am.perc),
           WindDir9am = as.factor(WindDir9am),
           WindSpeed9am.kmh = as.numeric(WindSpeed9am.kmh),
           Pressure9am.hPa = as.numeric(Pressure9am.hPa),
           Temp3pm.C = as.numeric(Temp3pm.C),
           Humidity3pm.perc = as.numeric(Humidity3pm.perc),
           WindDir3pm = as.factor(WindDir3pm),
           WindSpeed3pm.kmh = as.numeric(WindSpeed3pm.kmh),
           Pressure3pm.hPa = as.numeric(Pressure3pm.hPa)
) %>% 
    select(-c(Cloud9am.oktas, Cloud3pm.oktas, Evaporation.mm, SunHrs))

write.csv(weather.clean, "melbourne_weather.csv", row.names = F)


# Optional, make time a factor

weather.9am = weather.clean %>% 
    select(Date, Temp9am.C, Humidity9am.perc, WindDir9am, WindSpeed9am.kmh, Pressure9am.hPa) %>% 
    mutate(Time = "Morning")

weather.3pm = weather.clean %>% 
    select(Date, Temp3pm.C, Humidity3pm.perc, WindDir3pm, WindSpeed3pm.kmh, Pressure3pm.hPa) %>% 
    mutate(Time = "Afternoon")

colnames(weather.9am) = colnames(weather.3pm) = c("Date", "Temp.C", "Humidity.perc", "WindDir", "WindSpeed.kmh", "Pressure.hPa", "Time")
weather.times = rbind(weather.9am, weather.3pm) %>% 
    mutate(Time = as.factor(Time),
           WindDir = as.factor(WindDir),
           Pressure.hPa = as.numeric(Pressure.hPa),
           Temp.C = as.numeric(Temp.C),
           Humidity.perc = as.numeric(Humidity.perc),
           WindSpeed.kmh = as.numeric(WindSpeed.kmh),
           Date = as.Date(Date))

write.csv(weather.times, "melbourne_weather_times.csv", row.names = F)
